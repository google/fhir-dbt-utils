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

{% macro test_identifier() %}

  {% set input_data %}
    [ STRUCT(
        "http://hl7.org/fhir/sid/us-ssn" AS `system`,
        "88888888" AS `value`
      ),
      STRUCT(
        "http://other-identifier.org" AS `system`,
        "55555555" AS `value`
      )
    ] as `identifier`
  {% endset %}

  {% set tests = {
    'return_social_security_number': {
      'test': fhir_dbt_utils.identifier("http://hl7.org/fhir/sid/us-ssn"),
      'expect': '88888888'
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}