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

{% macro run_unit_tests_bigquery() %}

    {# fhir_analysis_macros #}
    {% do test_bucket() %}
    {% do test_length_of_stay() %}
    {% do test_official_name() %}
    {% do test_identifier() %}
    {% do test_full_address() %}
    {% do test_code_from_codeableconcept() %}
    {% do test_value_from_component() %}
    {% do test_has_value() %}
    {% do test_string_to_date() %}

    {# string_macros #}
    {% do test_quote_array() %}
    {% do test_find_first_of() %}
    {% do test_camel_case_to_snake_case() %}
    {% do test_snake_case_to_proper_case() %}

{% endmacro %}