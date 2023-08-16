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

{%- macro code_from_codeableconcept(
  field_name,
  code_system,
  fhir_resource=None,
  return_field='code',
  is_array=None
) -%}

  {%- if is_array != None %}
    {%- set field_is_array = is_array -%}
  {%- else %}
    {%- set field_is_array = fhir_dbt_utils.field_is_array(field_name, fhir_resource) -%}
  {%- endif %}

  {%- if field_is_array %}
    {%- set arrays = [
          fhir_dbt_utils.array_config(field = field_name, unnested_alias = "f"),
          fhir_dbt_utils.array_config(field = "f.coding", unnested_alias = "c")
        ]
    -%}
  {%- else %}
    {%- set arrays = [
          fhir_dbt_utils.array_config(field = field_name~".coding", unnested_alias = "c")
        ]
    -%}
  {%- endif -%}

  ({{ fhir_dbt_utils.select_from_unnest(
        select = "c." ~ return_field,
        unnested = fhir_dbt_utils.unnest_multiple(arrays),
        where = "c.system = '" ~ code_system ~ "'",
        order_by = "c.code"
      )
  }})

{%- endmacro %}