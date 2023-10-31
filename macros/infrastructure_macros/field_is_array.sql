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

{%- macro field_is_array(field_name, fhir_resource=None) -%}

{#- Validate input arguments -#}

  {%- set errors = [] -%}

  {%- if field_name is not string -%}
    {%- do errors.append("field_name argument must be a string. Got: " ~ field_name) -%}
  {%- endif -%}

  {%- if fhir_resource != None and fhir_resource is not string -%}
    {%- do errors.append("fhir_resource argument must be a string. Got: " ~ fhir_resource) -%}
  {%- endif -%}

  {%- do exceptions.raise_compiler_error("Macro input error(s):\n" ~ errors|join('. \n')) if errors -%}


{#- Macro logic -#}

  {% set fhir_resource = fhir_dbt_utils.get_fhir_resource(fhir_resource) %}

  {% set datatype_dict = fhir_dbt_utils.get_datatype_dict(fhir_resource) %}

  {% set field_is_array =
      field_name in datatype_dict
      and datatype_dict[field_name].startswith('ARRAY')
  %}

  {% do return(field_is_array) %}

{% endmacro %}