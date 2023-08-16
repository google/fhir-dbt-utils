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

{% macro test_full_address() %}

  {% set input_data %}
    [ STRUCT(
        "home" AS `use`,
        ["615 Synthea Lane", "Suite 4"] AS `line`,
        "Boston" AS `city`,
        "Massachusetts" AS `state`,
        "US" AS `country`,
        "02111" AS `postalCode`
      ),
      STRUCT(
        "work" AS `use`,
        ["1 Main Road"] AS `line`,
        "Boston" AS `city`,
        "Massachusetts" AS `state`,
        "US" AS `country`,
        "02222" AS `postalCode`
      )
    ] as `address`
  {% endset %}

  {% set tests = {
    'return_home_address': {
      'test': fhir_dbt_utils.full_address(),
      'expect': '615 Synthea Lane, Suite 4, Boston, Massachusetts, 02111, US'
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}