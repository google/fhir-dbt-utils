-- Copyright 2023 Google LLC
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

{% macro build_union_query(fhir_tables) %}

{%- set relations = fhir_dbt_utils.raw_tables_to_relations(fhir_tables) %}
{%- set relation_columns = {} -%}
{%- set column_superset = {} -%}
{%- set column_data_type_clash = [] -%}
{%- set metric_date_columns = fhir_dbt_utils.get_metric_date_columns() -%}

{#- Iterate through tables to produce superset of all columns -#}
{%- for relation in relations -%}
  {%- set columns = adapter.get_columns_in_relation(relation) -%}
  {%- do relation_columns.update({relation: []}) -%}
  {%- for col in columns -%}
    {%- do relation_columns[relation].append(col.column) -%}
      {% for sub_col in flatten_column(col) %}
        {% do relation_columns[relation].append(sub_col.column) %}
      {%- endfor -%}
    {%- if col.column not in column_superset -%}
      {%- do column_superset.update({col.column: col.data_type}) -%}
    {%- else -%}
      {%- set data_type_existing = column_superset[col.column] -%}
      {%- if col.data_type != data_type_existing %}
        {%- do column_data_type_clash.append(col.column) -%}
      {%- endif -%}
      {%- do column_superset.update({col.column: col.data_type}) -%}
    {%- endif -%}
  {%- endfor -%}
{%- endfor -%}

{#- Iterate through tables to create a select statement per table -#}
{%- for relation in relations %}

    {#- Filter list of metric date columns to only those that are mapped in table -#}
    {%- if metric_date_columns != None %}
      {%- for date_column in metric_date_columns %}
        {%- do metric_date_columns.remove(date_column) if date_column not in relation_columns[relation] -%}
      {%- endfor %}
    {%- endif %}
    {%- if metric_date_columns == [] %}
      {%- set metric_date_columns = None %}
    {%- endif %}

SELECT
  {#- Iterate through columns that exist in all tables for this FHIR resource -#}
  {%- for column in column_superset %}
    {%- if column in column_data_type_clash %}
    'subfield_mismatch' AS {{ column }},
    {%- else -%}
    {%- set col_name = adapter.quote(column) if column in relation_columns[relation] else 'null' %}
    {{ col_name }} AS {{ column }},
    {%- endif -%}
  {%- endfor -%}

  {#- Add additional derived columns to the view #}
    '{{ relation.identifier }}' AS fhir_mapping

FROM {{ relation }}
{%- if not loop.last %}
UNION ALL
{%- endif -%}
{%- endfor -%}

{% endmacro %}