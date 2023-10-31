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

{% macro get_snapshot_date(snapshot_date=None)-%}

{#- Validate input arguments -#}

  {%- if snapshot_date != None and snapshot_date is not string -%}
    {%- do exceptions.raise_compiler_error("Macro input error: snapshot_date argument must be a string. Got: " ~ snapshot_date) -%}
  {%- endif -%}


{#- Macro logic -#}

  {#- 1st choice: snapshot_date argument provided in model -#}
  {%- if snapshot_date != None -%}
    {%- do return("DATE('" ~ snapshot_date ~ "')") -%}

  {#- 2nd choice: snapshot_date specified by project variable -#}
  {%- elif var('snapshot_date') != "None" -%}
    {%- do return("DATE('" ~ var('snapshot_date') ~ "')") -%}

  {#- 3rd choice: default to today's date -#}
  {%- else -%}
        {%- do return('CURRENT_DATE()') -%}
  {%- endif -%}

{%- endmacro %}