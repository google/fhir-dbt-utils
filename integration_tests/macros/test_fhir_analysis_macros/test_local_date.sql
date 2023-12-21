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

{% macro test_local_date() %}

  {% set input_data = {
    'time_stamp_4am': 'TIMESTAMP("2023-12-18T04:00:00+00:00")',
    'time_stamp_6am': 'TIMESTAMP("2023-12-18T06:00:00+00:00")',
    'time_stamp_string_7am': '"2023-12-18T07:00:00+00:00"',
    'time_stamp_string_9am': '"2023-12-18T09:00:00+00:00"',
    'date_only': '"2017-04-01"'
  } %}
  {# New York is the default in dbt_project.yml. #}
  {% set tests = {
    'timestamp_New_York_one_day_earlier': {
      'test': fhir_dbt_utils.local_date('time_stamp_4am', 'TIMESTAMP'),
      'expect': "2023-12-17",
    },
    'timestamp_New_York_same_day': {
      'test': fhir_dbt_utils.local_date('time_stamp_6am', 'TIMESTAMP'),
      'expect': "2023-12-18",
    },
    'date_only_Los_Angeles_stays_the_same': {
      'test': fhir_dbt_utils.local_date('date_only', 'DATE', 'America/Los_Angeles'),
      'expect': "2017-04-01",
    },
    'timestamp_string_Los_Angeles_one_day_earlier': {
      'test': fhir_dbt_utils.local_date('time_stamp_string_7am', 'STRING', 'America/Los_Angeles'),
      'expect': "2023-12-17",
    },
    'timestamp_string_Los_Angeles_same_day': {
      'test': fhir_dbt_utils.local_date('time_stamp_string_9am', 'STRING', 'America/Los_Angeles'),
      'expect': "2023-12-18",
    },
  } %}

  {{ perform_tests_cross_db(input_data, tests) }}

{% endmacro %}
