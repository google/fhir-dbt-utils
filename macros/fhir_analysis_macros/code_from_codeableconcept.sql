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

{#- Validate input arguments -#}

  {%- set errors = [] -%}

  {%- if field_name is not string -%}
    {%- do errors.append("field_name argument must be a string. Got: " ~ field_name) -%}
  {%- endif -%}

  {%- if code_system is not string -%}
    {%- do errors.append("code_system argument must be a string. Got: " ~ code_system) -%}
  {%- endif -%}

  {%- if fhir_resource != None and fhir_resource is not string -%}
    {%- do errors.append("fhir_resource argument must be a string. Got: " ~ fhir_resource) -%}
  {%- endif -%}

  {%- if return_field is not string -%}
    {%- do errors.append("return_field argument must be a string. Got: " ~ return_field) -%}
  {%- elif return_field not in ('code', 'display') -%}
    {%- do errors.append("return_field must be one of 'code' or 'display'. Got " ~ return_field) -%}
  {%- endif -%}

  {%- if is_array != None and is_array is not boolean -%}
    {%- do errors.append("is_array argument must be a boolean (True/False). Got: " ~ is_array) -%}
  {%- endif -%}

  {%- do exceptions.raise_compiler_error("Macro input error(s):\n" ~ errors|join('. \n')) if errors -%}


{#- Macro logic -#}

  {#- Validate that the field is a codeableConcept -#}

  {%- set fhir_resource = fhir_dbt_utils.get_fhir_resource(fhir_resource) -%}
  {%- set datatype_dict = fhir_dbt_utils.get_datatype_dict(fhir_resource) -%}

  {%- if execute
    and var('assume_fields_exist') == False
    and (
        field_name~'.coding.code' not in datatype_dict or
        field_name~'.coding.system' not in datatype_dict
      )
  -%}
    {{ return("'missing_or_invalid_codeableconcept_field: "~field_name~"'") }}
  {%- endif -%}


  {#- Identify whether the field is an array -#}

  {%- if is_array != None %}
    {%- set field_is_array = is_array -%}
  {%- else %}
    {%- set field_is_array = fhir_dbt_utils.field_is_array(field_name) -%}
  {%- endif %}


  {#- Construct SQL -#}

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