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

{% macro test_length_of_stay() %}

  {# Scenario 1 - period.end has a value #}

  {% set input_data %}
    STRUCT(
      "2017-04-04T17:00:00+00:00" AS `end`,
      "2017-04-01T12:00:00+00:00" AS `start`
    ) AS `period`
  {% endset %}

  {% set tests = {
    'default_args': {
      'test': fhir_dbt_utils.length_of_stay(),
      'expect': 3,
    },
    'date_part_week': {
      'test': fhir_dbt_utils.length_of_stay(date_part='WEEK'),
      'expect': 1,
    }
  } %}

  {{ perform_tests(input_data, tests) }}


  {# Scenario 2 - period.end is null (i.e. encounter is ongoing) #}

  {% set input_data %}
    STRUCT(
      CAST(NULL AS STRING) AS `end`,
      "2017-04-01T12:00:00+00:00" AS `start`
    ) AS `period`
  {% endset %}

  {% set tests = {
    'null_period_end_default_args': {
      'test': fhir_dbt_utils.length_of_stay(),
      'expect': None,
    },
    'null_period_end_los_for_ongoing_encounters_true': {
      'test': fhir_dbt_utils.length_of_stay(los_for_ongoing_encounters=True),
      'expect': 2101,
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}