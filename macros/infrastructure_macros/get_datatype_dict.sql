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

{% macro get_datatype_dict(fhir_resource, from_source_data = False) %}

{#- Validate input arguments -#}

  {%- if fhir_resource is not string -%}
    {%- do exceptions.raise_compiler_error("Macro input error: fhir_resource argument must be a string. Got: " ~ fhir_resource) -%}
  {%- endif -%}


{#- Macro logic -#}

  {%- if execute -%}

    {% if from_source_data %}
      {% set table_name = get_tables_for_resource(fhir_resource)[0] %}
      {% set database = var('database') %}
      {% set schema = var('schema') %}
    {% else %}
      {% set table_name = fhir_resource %}
      {% set database = target.project %}
      {% set schema = target.schema %}
    {% endif %}

    {% set relation = adapter.get_relation(
          database = database, schema = schema, identifier = table_name) %}
    {% if not relation %}
      {% do exceptions.raise_compiler_error(
           "Table not found: " ~ database ~"."~schema~"."~table_name) %}
    {% endif %}

    {%- set column_dict = {} -%}

    {%- set columns = adapter.get_columns_in_relation(relation) -%}
    {% for top_level_column in columns %}
      {%- do column_dict.update({top_level_column.name: top_level_column.data_type}) -%}
      {% for column in fhir_dbt_utils.flatten_column(top_level_column) %}
        {%- do column_dict.update({column.name: column.data_type}) -%}
      {% endfor %}
    {%- endfor -%}

  {% endif %}

  {%- do return(column_dict) -%}

{% endmacro %}