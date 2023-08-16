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

{% macro get_fhir_resource(fhir_resource=None) %}

  {%- if execute -%}

    {#- 1st choice: fhir_resource argument provided to macro -#}
    {%- if fhir_resource != None -%}
      {%- set fhir_resource = fhir_resource -%}
    {%- endif -%}

    {#- 2nd choice: fhir_resource specified by fhir_resource key in model metadata -#}
    {%- if fhir_resource == None -%}
      {%- set fhir_resource = fhir_dbt_utils.model_metadata(meta_key='fhir_resource') -%}
    {%- endif -%}

    {#- 3rd choice: fhir_resource specified by primary_resource key in model metadata -#}
    {%- if fhir_resource == None -%}
      {%- set fhir_resource = fhir_dbt_utils.model_metadata(meta_key='primary_resource') -%}
    {%- endif -%}

    {#- If no FHIR resource retrieved then raise error -#}
    {%- if fhir_resource == None -%}
        {{ exceptions.raise_compiler_error("fhir_resource argument not provided and not found in model metadata") }}
    {%- endif -%}

  {%- endif -%}

  {%- do return(fhir_resource) -%}

{% endmacro %}