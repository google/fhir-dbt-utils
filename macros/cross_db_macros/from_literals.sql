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

{% macro from_literals(field_to_value) -%}
  {{ return (adapter.dispatch('from_literals', 'fhir_dbt_utils') (field_to_value)) }}
{%- endmacro %}


{% macro default__from_literals(field_to_value) -%}
  ( SELECT {% for field in field_to_value -%}{{ field_to_value[field] }} AS `{{ field }}`,{% endfor %} )
{%- endmacro -%}


{% macro spark__from_literals(field_to_value) -%}
  VALUES ({% for field in field_to_value -%}{{ field_to_value[field] }}{% if not loop.last %},{% endif %}{% endfor %})
  AS DATA({% for field in field_to_value -%}{{ field }}{% if not loop.last %},{% endif %}{% endfor %})
{%- endmacro %}
