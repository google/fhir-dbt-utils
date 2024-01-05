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

{%- macro fhir_resource_view_expression() -%}

{%- if execute -%}

    {%- set fhir_resource = fhir_dbt_utils.model_metadata(meta_key='fhir_resource') -%}

    {% if var('snake_case_fhir_tables') %}
        {% set fhir_table = fhir_dbt_utils.camel_case_to_snake_case(fhir_resource) %}
    {% else %}
        {% set fhir_table = fhir_resource %}
    {% endif %}

{%- if target.name == "internal_pipeline"  -%}
    {%- set metric_date_columns = fhir_dbt_utils.get_metric_date_columns() -%}
    {%- set date_column_data_type = 'STRING' -%}
SELECT
    *,
    {%- if fhir_resource not in ('Binary') %}
    meta.mappingId AS fhir_mapping,
    {%- else %}
    NULL AS fhir_mapping,
    {%- endif %}
    {{ fhir_dbt_utils.metric_date(metric_date_columns, date_column_data_type) }} AS metric_date,
    {{ fhir_dbt_utils.metric_hour(metric_date_columns, date_column_data_type) }} AS metric_hour
FROM {{fhir_table}}
{% elif not fhir_dbt_utils.fhir_resource_exists(fhir_resource) %}
    {%- do exceptions.warn("FHIR resource " ~ fhir_table ~ " does not exist in your database. Creating a dummy view with 1 row") -%}
    {{ fhir_dbt_utils.create_dummy_table() }}
{%- elif var('multiple_tables_per_resource') -%}
    {% set fhir_tables = fhir_dbt_utils.get_tables_for_resource(fhir_resource) %}
    {{ return(fhir_dbt_utils.build_union_query(fhir_tables)) }}
{%- else %}
    {%- set metric_date_columns = fhir_dbt_utils.get_metric_date_columns() -%}
    {%- set datatype_dict = fhir_dbt_utils.get_datatype_dict(fhir_resource, database = var('database'), schema = var('schema')) -%}
    {%- set date_column_data_type = datatype_dict[metric_date_columns[0]] %}
SELECT
    *,
    CAST(NULL AS STRING) AS fhir_mapping,
    {{ fhir_dbt_utils.metric_date(metric_date_columns, date_column_data_type) }} AS metric_date,
    {{ fhir_dbt_utils.metric_hour(metric_date_columns, date_column_data_type) }} AS metric_hour
FROM {{ source('fhir', fhir_table) }}
{%- endif -%}

{%- endif -%}

{%- endmacro -%}