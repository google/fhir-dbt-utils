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
{%- else %}
    {%- set fhir_resource = 'N/A' -%}
{%- endif -%}

{% if var('snake_case_fhir_tables') %}
    {% set fhir_table = fhir_dbt_utils.camel_case_to_snake_case(fhir_resource) %}
{% else %}
    {% set fhir_table = fhir_resource %}
{% endif %}

{%- if target.name == "internal_pipeline"  -%}
SELECT *
FROM {{fhir_table}}
{% elif not fhir_dbt_utils.fhir_resource_exists(fhir_resource) %}
    {{ fhir_dbt_utils.create_dummy_table() }}
{%- elif var('multiple_tables_per_resource') -%}
    {% set fhir_tables = fhir_dbt_utils.get_tables_for_resource(fhir_resource) %}
    {{ return(fhir_dbt_utils.build_union_query(fhir_tables)) }}
{%- else %}
SELECT *
FROM {{ source('fhir', fhir_table) }}
{%- endif -%}

{%- endmacro -%}