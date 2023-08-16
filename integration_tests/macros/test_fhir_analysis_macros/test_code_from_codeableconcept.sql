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

{% macro test_code_from_codeableconcept() %}

  {% set input_data %}
    STRUCT(
      [ STRUCT(
        "55284-4" AS `code`,
        "Blood Pressure" AS `display`,
        "http://loinc.org" AS `system`
      )] AS `coding`,
      "Blood Pressure" AS `text`
    ) AS `code`
  {% endset %}

  {% set tests = {
    'return_code': {
      'test': fhir_dbt_utils.code_from_codeableconcept(
        field_name='code',
        code_system='http://loinc.org',
        fhir_resource='Observation',
        is_array=False
      ),
      'expect': '55284-4'
    },
    'return_display': {
      'test': fhir_dbt_utils.code_from_codeableconcept(
        field_name='code',
        code_system='http://loinc.org',
        fhir_resource='Observation',
        return_field='display',
        is_array=False
      ),
      'expect': 'Blood Pressure'
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}