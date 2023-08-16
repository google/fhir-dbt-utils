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

{% macro test_snake_case_to_proper_case() %}

  {% set input_data %}
    "foo" AS `foo`,
    "foo_bar" AS `foo_bar`
  {% endset %}

  {% set tests = {
    'lower_case': {
      'test': fhir_dbt_utils.snake_case_to_proper_case('foo'),
      'expect': "Foo"
    },
    'snake_case': {
      'test': fhir_dbt_utils.snake_case_to_proper_case('foo_bar'),
      'expect': "Foo Bar"
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}