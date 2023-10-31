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

{% macro raw_tables_to_relations(input_tables) %}

    {# Initialise array #}
    {% set relationArray = [] %}

    {# Append relations based on raw config and table names #}
    {% for input_table in input_tables %}
        {{ relationArray.append(api.Relation.create(
               database=var('database'), schema=var('schema'), identifier=input_table)) }}
    {% endfor %}

    {{ return(relationArray) }}

{% endmacro %}