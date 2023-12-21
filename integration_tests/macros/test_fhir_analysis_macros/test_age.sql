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

{% macro test_age() %}

  {# Scenario 1 - default date_of_birth_field #}

  {% set input_data = {
    'birthDate': '"1950-01-01"'
  } %}

  {% set tests = {
    'default_date_of_birth_field': {
      'test': fhir_dbt_utils.age(snapshot_date="2023-01-01"),
      'expect': 73
    }
  } %}

  {{ perform_tests_cross_db(input_data, tests) }}


  {# Scenario 2 - date_of_birth_field specified #}

  {% set input_data = {
    'dob': '"1970-01-01"'
  } %}

  {% set tests = {
    'set_date_of_birth_field': {
      'test': fhir_dbt_utils.age(
        date_of_birth_field="dob",
        snapshot_date="2023-01-01"
      ),
      'expect': 53
    }
  } %}

  {{ perform_tests_cross_db(input_data, tests) }}

{% endmacro %}