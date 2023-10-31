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

{%- macro identifier(system) -%}

{#- Validate input arguments -#}

  {%- if system is not string -%}
    {%- do exceptions.raise_compiler_error("Macro input error: system argument must be a string. Got: " ~ system) -%}
  {%- endif -%}


{#- Macro logic -#}

  (SELECT value FROM UNNEST(identifier) WHERE system = '{{system}}')

{%- endmacro -%}