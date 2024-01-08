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

-- Run using: dbt run-operation run_unit_tests

{% macro run_unit_tests_cross_db() %}

    {# cross_db_macros #}
    {% do test_flatten_column() %}
    {% do test_unnest() %}
    {% do test_unnest_multiple() %}
    {% do test_select_from_unnest() %}

    {# fhir_analysis_macros #}
    {% do test_local_hour() %}
    {% do test_local_date() %}
    {% do test_alive() %}
    {% do test_age() %}

    {# string_macros #}
    {% do test_quote_array() %}
    {% do test_find_first_of() %}
    {% do test_camel_case_to_snake_case() %}
    {% do test_snake_case_to_proper_case() %}

{% endmacro %}