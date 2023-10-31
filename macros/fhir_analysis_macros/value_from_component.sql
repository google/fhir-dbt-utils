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

{%- macro value_from_component(
  code,
  code_system,
  return_field='quantity.value'
) -%}

{#- Validate input arguments -#}

  {%- set errors = [] -%}

  {%- if code is not string -%}
    {%- do errors.append("code argument must be a string. Got: " ~ code) -%}
  {%- endif -%}

  {%- if code_system is not string -%}
    {%- do errors.append("code_system argument must be a string. Got: " ~ code_system) -%}
  {%- endif -%}

  {%- if return_field is not string -%}
    {%- do errors.append("return_field argument must be a string. Got: " ~ return_field) -%}
  {%- elif return_field not in ('quantity.value', 'string', 'boolean', 'integer', 'time', 'dateTime') -%}
      {{ errors.append("return_field must be one of 'quantity.value', 'string', 'boolean', 'integer', 'time' or 'dateTime'. Got " ~ return_field) }}
  {%- endif -%}

  {%- do exceptions.raise_compiler_error("Macro input error(s):\n" ~ errors|join('. \n')) if errors -%}


{#- Macro logic -#}

  {%- set arrays = [
        fhir_dbt_utils.array_config(field = "component", unnested_alias = "c"),
        fhir_dbt_utils.array_config(field = "c.code.coding", unnested_alias = "cc")
      ]
  -%}

  ({{ fhir_dbt_utils.select_from_unnest(
        select = "c.value." ~ return_field,
        unnested = fhir_dbt_utils.unnest_multiple(arrays),
        where = "cc.system = '" ~ code_system ~ "' AND cc.code = '" ~ code ~ "'",
        order_by = "cc.code"
      )
  }})

{%- endmacro %}