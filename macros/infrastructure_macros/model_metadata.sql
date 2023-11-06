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

{% macro model_metadata(meta_key, value_if_missing=None) %}

{#- Validate input arguments -#}

  {%- set errors = [] -%}

  {%- if meta_key is not string -%}
    {%- do exceptions.raise_compiler_error("meta_key argument must be a string. Got: " ~ meta_key) -%}

  {%- endif -%}


{#- Macro logic -#}

  {%- if execute -%}

    {% set meta_value = model.config.meta[meta_key] %}

    {% if not meta_value %}

      {%- do exceptions.warn("Value not found for key in model metadata") -%}
      {%- do return(value_if_missing) -%}

    {% else %}

      {% do return(meta_value) %}

    {% endif %}

  {% endif %}

{% endmacro %}


