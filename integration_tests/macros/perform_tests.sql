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

{% macro perform_tests(input_data, tests) %}

  {# Write a SQL query to run each test over the input data #}
  {% set query %}
    SELECT
      {% for test_name, test_object in tests.items() -%}
        {{test_object.test | trim}} AS {{test_name}},
      {% endfor %}
    FROM ( SELECT {{ input_data }} )
  {% endset %}

  {# Execute the SQL query and save the results in a dictionary  #}
  {% set query_result = dbt_utils.get_query_results_as_dict(query) %}

  {# For each result compare with the expected value defined in the test #}
  {% for test_name in tests -%}
    {% set value = query_result[test_name][0]%}
    {% set expected = tests[test_name].expect %}
    {% if value|string == expected|string %}
      {% do log("SUCCESSFUL UNIT TEST:" ~ test_name ~ ".") %}
    {% else %}
      {% do exceptions.raise_compiler_error(
        "FAILED UNIT TEST: " ~ test_name ~ ". Expected: " ~ expected ~ ". Returned: " ~ value ~ "."
      ) %}
    {% endif %}
  {% endfor %}

{% endmacro %}