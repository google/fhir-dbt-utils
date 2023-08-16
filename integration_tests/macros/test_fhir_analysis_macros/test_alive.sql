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

{% macro test_alive() %}

  {# Scenario 1 - deceasedDateTime has a value #}

  {% set input_data %}
    STRUCT(
      "2022-09-01T22:35:00+00:00" AS `dateTime`
    ) as `deceased`
  {% endset %}

  {% set tests = {
    'default_args': {
      'test': fhir_dbt_utils.alive(),
      'expect': False
    },
    'include_snapshot_date': {
      'test': fhir_dbt_utils.alive(snapshot_date="2021-01-01"),
      'expect': True
    }
  } %}

  {{ perform_tests(input_data, tests) }}


  {# Scenario 2 - deceasedDateTime is null #}

  {% set input_data %}
    STRUCT(
      FALSE AS `boolean`,
      CAST(NULL AS STRING) AS `dateTime`
    ) as `deceased`
  {% endset %}

  {% set tests = {
    'default_args_datetime_null': {
      'test': fhir_dbt_utils.alive(),
      'expect': True
    },
      'include_snapshot_date_datetime_null': {
      'test': fhir_dbt_utils.alive(snapshot_date="2021-01-01"),
      'expect': True
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}