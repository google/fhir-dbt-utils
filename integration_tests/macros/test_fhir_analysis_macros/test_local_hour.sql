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


{% macro test_local_hour() -%}
  {% set input_data = {
    'time_stamp_4_20': 'TIMESTAMP("2023-12-18T04:20:00+00:00")',
    'time_stamp_6_40': 'TIMESTAMP("2023-12-18T06:40:00+00:00")',
    'time_stamp_string_7_40': '"2023-12-18T07:40:00+00:00"',
    'date_only': '"2017-04-01"'
  } %}

  {{ return(adapter.dispatch('test_local_hour', 'fhir_dbt_utils') (input_data)) }}
{%- endmacro %}


{% macro default__test_local_hour(input_data) -%}
  {# New York is the default in dbt_project.yml. #}
  {% set tests = {
    'timestamp_New_York_4_20': {
      'test': fhir_dbt_utils.local_hour('time_stamp_4_20', 'TIMESTAMP'),
      'expect': "2023-12-18 04:00:00+00:00",
    },
    'timestamp_New_York_6_40': {
      'test': fhir_dbt_utils.local_hour('time_stamp_6_40', 'TIMESTAMP'),
      'expect': "2023-12-18 06:00:00+00:00",
    },
    'date_only': {
      'test': fhir_dbt_utils.local_hour('date_only', 'DATE'),
      'expect': None,
    },
    'timestamp_string_7_40': {
      'test': fhir_dbt_utils.local_hour('time_stamp_string_7_40', 'STRING'),
      'expect': "2023-12-18 07:00:00+00:00",
    },
  } %}

  {{ perform_tests_cross_db(input_data, tests) }}
{%- endmacro %}


{% macro spark__test_local_hour(input_data) -%}
  {# New York is the default in dbt_project.yml. #}
  {% set tests = {
    'timestamp_New_York_4_20': {
      'test': fhir_dbt_utils.local_hour('time_stamp_4_20', 'TIMESTAMP'),
      'expect': "2023-12-18 04:00:00",
    },
    'timestamp_New_York_6_40': {
      'test': fhir_dbt_utils.local_hour('time_stamp_6_40', 'TIMESTAMP'),
      'expect': "2023-12-18 06:00:00",
    },
    'date_only': {
      'test': fhir_dbt_utils.local_hour('date_only', 'DATE'),
      'expect': None,
    },
    'timestamp_string_7_40': {
      'test': fhir_dbt_utils.local_hour('time_stamp_string_7_40', 'STRING'),
      'expect': "2023-12-18 07:00:00",
    },
  } %}

  {{ perform_tests_cross_db(input_data, tests) }}
{%- endmacro %}

