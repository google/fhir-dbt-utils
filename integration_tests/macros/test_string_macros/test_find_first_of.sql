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

{% macro test_find_first_of() %}

    {{ dbt_unittest.assert_equals(fhir_dbt_utils.find_first_of("foobar", "f"), 0) }}
    {{ dbt_unittest.assert_equals(fhir_dbt_utils.find_first_of("foobar", "o"), 1) }}
    {{ dbt_unittest.assert_equals(fhir_dbt_utils.find_first_of("foobar", "br"), 3) }}
    {{ dbt_unittest.assert_equals(fhir_dbt_utils.find_first_of("foobar", "c"), -1) }}

{% endmacro %}