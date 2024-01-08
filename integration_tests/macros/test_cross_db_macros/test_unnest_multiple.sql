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

{% macro test_unnest_multiple() -%}
  {{ return(adapter.dispatch('test_unnest_multiple', 'fhir_dbt_utils') ()) }}
{%- endmacro %}


{% macro default__test_unnest_multiple() -%}
  {{ fhir_dbt_utils.assert_string_equals(
      fhir_dbt_utils.unnest_multiple(
        [fhir_dbt_utils.array_config( field = 'my_array', unnested_alias = 'c' )],
      ),
  "UNNEST(my_array) c") }}

  {{ fhir_dbt_utils.assert_string_equals(
      fhir_dbt_utils.unnest_multiple(
        [fhir_dbt_utils.array_config( field = 'my_array_2', unnested_alias = 'm' ),
         fhir_dbt_utils.array_config( field = 'm.foos', unnested_alias = 'd' )],
      ),
  "UNNEST(my_array_2) m, UNNEST(m.foos) d") }}
{%- endmacro %}


{% macro spark__test_unnest_multiple() -%}
  {{ fhir_dbt_utils.assert_string_equals(
      fhir_dbt_utils.spark__unnest_multiple(
        arrays = [fhir_dbt_utils.array_config( field = 'my_array', unnested_alias = 'c' )],
      ),
  "SELECT * FROM (SELECT EXPLODE(ac) AS c FROM (SELECT my_array AS ac))") }}

  {{ fhir_dbt_utils.assert_string_equals(
      fhir_dbt_utils.spark__unnest_multiple(
        arrays = [
          fhir_dbt_utils.array_config( field = 'my_array_2', unnested_alias = 'm' ),
          fhir_dbt_utils.array_config( field = 'm.foos', unnested_alias = 'd' )],
      ),
  "SELECT * FROM (SELECT EXPLODE(ac) AS m FROM (SELECT my_array_2 AS ac))
    LATERAL VIEW OUTER explode (m.foos) AS d
  )") }}

{% endmacro %}