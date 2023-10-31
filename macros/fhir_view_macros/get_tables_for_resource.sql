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

{% macro get_tables_for_resource(fhir_resource) %}

    {# Build query to check for all tables of a certain FHIR resource #}
    {%- call statement('result', fetch_result=True) -%}
    SELECT DISTINCT bq_table
    FROM {{ ref('fhir_table_list') }} AS L
    WHERE fhir_resource = '{{ fhir_resource }}'
    AND latest_version = 1
    {%- endcall -%}

    {# Return result, or dummy array of ['Observation'] if result is empty #}
    {% if execute %}
        {{ return(load_result('result').table.columns[0].values()) }}
    {% else %}
        {{ return(['Observation']) }}
    {% endif %}

{% endmacro %}