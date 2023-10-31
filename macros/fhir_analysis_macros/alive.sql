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

{%- macro alive(
  date_of_death_field='deceased.dateTime',
  snapshot_date=None
) -%}

{#- Validate input arguments -#}

  {%- if date_of_death_field is not string -%}
    {%- do exceptions.raise_compiler_error("Macro input error: date_of_death_field argument must be a string. Got: " ~ date_of_death_field) -%}
  {%- endif -%}


{#- Macro logic -#}

  {%- set snapshot_date = fhir_dbt_utils.get_snapshot_date(snapshot_date) -%}

  ({{date_of_death_field}} IS NULL OR DATE({{date_of_death_field}}) > {{snapshot_date}})

{%- endmacro -%}