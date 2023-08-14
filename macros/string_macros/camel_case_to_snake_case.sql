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

{% macro camel_case_to_snake_case(str) %}
    {#- Add underscore before capital letters which follow lowercase letters -#}
    {% set str = modules.re.sub("([a-z])([A-Z])", "\\1_\\2", str) %}
    {#- Lower case the string -#}
    {{ return(str | lower) }}
{% endmacro %}