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

{%- macro bucket(
  field,
  boundaries_array=[00, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
) -%}

  CASE RANGE_BUCKET({{field}}, {{boundaries_array}})
    WHEN 0 THEN '< {{boundaries_array[0]}}'
  {% for i in range(1, boundaries_array|length) -%}
    WHEN {{i}} THEN '{{boundaries_array[i-1]}} - {{boundaries_array[i]}}'
  {% endfor -%}
    WHEN {{boundaries_array|length}} THEN '>= {{boundaries_array[-1]}}'
  ELSE NULL END

{%- endmacro -%}