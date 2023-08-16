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

{% macro test_value_from_component() %}

  {# Scenario 1 - component.value.quantity.value recorded #}

  {% set input_data %}
    [ STRUCT(
        STRUCT(
          [ STRUCT(
              "8480-6" AS `code`,
              "Systolic Blood Pressure" AS `display`,
              "http://loinc.org" AS `system`
            )
          ] AS `coding`,
          "Systolic Blood Pressure"  AS `text`
        ) as `code`,
        STRUCT(
          STRUCT(
            120 AS `value`
          ) as `quantity`
        ) as `value`
      ),
      STRUCT(
        STRUCT(
          [ STRUCT(
              "8462-4" AS `code`,
              "Diastolic Blood Pressure" AS `display`,
              "http://loinc.org" AS `system`
            )
          ] AS `coding`,
          "Diastolic Blood Pressure"  AS `text`
        ) as `code`,
        STRUCT(
          STRUCT(
            80 AS `value`
          ) as `quantity`
        ) as `value`
      )
    ] as `component`

  {% endset %}

  {% set tests = {
    'return_quantity_value_systolic': {
      'test': fhir_dbt_utils.value_from_component(
        code='8480-6',
        code_system='http://loinc.org',
        return_field='quantity.value'
      ),
      'expect': 120
    },
    'return_quantity_value_diastolic': {
      'test': fhir_dbt_utils.value_from_component(
        code='8462-4',
        code_system='http://loinc.org',
        return_field='quantity.value'
      ),
      'expect': 80
    }
  } %}

  {{ perform_tests(input_data, tests) }}

  {# Scenario 2 - component.value.string recorded #}

  {% set input_data %}
    [ STRUCT(
        STRUCT(
          [ STRUCT(
              "55284-4" AS `code`,
              "Blood Pressure" AS `display`,
              "http://loinc.org" AS `system`
            )
          ] AS `coding`,
          "Blood Pressure"  AS `text`
        ) as `code`,
        STRUCT(
          "120/80 mmHg" AS `string`
        ) as `value`
      )
    ] as `component`

  {% endset %}

  {% set tests = {
    'return_string_blood_pressure': {
      'test': fhir_dbt_utils.value_from_component(
        code='55284-4',
        code_system='http://loinc.org',
        return_field='string'
      ),
      'expect': "120/80 mmHg"
    }
  } %}

  {{ perform_tests(input_data, tests) }}

{% endmacro %}
