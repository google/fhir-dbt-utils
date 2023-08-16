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

{% macro test_official_name() %}

  {% set input_data %}
    [ STRUCT(
      "Smith" AS `family`,
      ["John", "Mark"] AS `given`,
      ["Mr"] AS `prefix`,
      ["III"] AS `suffix`,
      "official" AS `use`
    )] as `name`
  {% endset %}

  {% set tests = {
    'default_args': {
      'test': fhir_dbt_utils.official_name(),
      'expect': 'Mr John Mark Smith III'
    },
    'include_prefix_false': {
      'test': fhir_dbt_utils.official_name(include_prefix=False),
      'expect': 'John Mark Smith III'
    },
    'include_middle_names_false': {
      'test': fhir_dbt_utils.official_name(include_middle_names=False),
      'expect': 'Mr John Smith III'
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}