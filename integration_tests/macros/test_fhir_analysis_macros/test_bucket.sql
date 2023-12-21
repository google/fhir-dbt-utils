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

{% macro test_bucket() %}

  {% set input_data %}
    68 AS `age`
  {% endset %}

  {% set tests = {
    'default_boundaries_array': {
      'test': fhir_dbt_utils.bucket(field="age"),
      'expect': '60 - 70'
    },
    'set_boundaries_array': {
      'test': fhir_dbt_utils.bucket(
        field="age",
        boundaries_array=[00, 18, 65]
      ),
      'expect': '>= 65'
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}