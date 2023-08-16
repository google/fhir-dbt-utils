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

{% macro test_quote_array() -%}

  {{ dbt_unittest.assert_equals(fhir_dbt_utils.quote_array([]), []) }}
  {{ dbt_unittest.assert_equals(fhir_dbt_utils.quote_array(["foo"]), ["'foo'"]) }}
  {{ dbt_unittest.assert_equals(fhir_dbt_utils.quote_array(["foo", "bar"]), ["'foo'", "'bar'"]) }}

  {{ return(adapter.dispatch('test_quote_array', 'fhir_dbt_utils') ()) }}
{%- endmacro %}


{% macro default__test_quote_array() -%}
  {{ dbt_unittest.assert_equals(fhir_dbt_utils.quote_array(["f'o'o"]), ["'f\\'o\\'o'"]) }}
{%- endmacro %}


{% macro spark__test_quote_array() -%}
  {{ dbt_unittest.assert_equals(fhir_dbt_utils.quote_array(["f'o'o"]), ["'f''o''o'"]) }}
{%- endmacro %}
