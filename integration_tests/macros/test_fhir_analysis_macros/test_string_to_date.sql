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

{% macro test_string_to_date() %}

  {% set input_data %}
    "1950-01-01" AS `date_as_string`,
    "2022-08-01T06:15:00+00:00" AS `date_time_as_string`
  {% endset %}

  {% set tests = {
    'date_as_string': {
      'test': fhir_dbt_utils.string_to_date(date_field="date_as_string", timezone="America/New_York"),
      'expect': "1950-01-01"
    },
    'date_time_as_string': {
      'test': fhir_dbt_utils.string_to_date(date_field="date_time_as_string", timezone="America/New_York"),
      'expect': "2022-08-01"
    },
    'date_time_as_string_timezone_shift': {
      'test': fhir_dbt_utils.string_to_date(date_field="date_time_as_string", timezone="America/Los_Angeles"),
      'expect': "2022-07-31"
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}