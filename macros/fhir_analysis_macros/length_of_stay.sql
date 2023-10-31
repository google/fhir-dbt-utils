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

{%- macro length_of_stay(
  date_part='DAY',
  los_for_ongoing_encounters=False
) -%}

{#- Validate input arguments -#}

  {%- set errors = [] -%}

  {%- if date_part is not string -%}
    {%- do errors.append("date_part argument must be a string. Got: " ~ date_part) -%}
  {%- elif date_part not in ('DAY', 'WEEK', 'ISOWEEK', 'MONTH', 'QUARTER', 'YEAR', 'ISOYEAR') -%}
      {{ errors.append("date_part must be one of 'DAY', 'WEEK', 'ISOWEEK', 'MONTH', 'QUARTER', 'YEAR' or 'ISOYEAR'. Got " ~ date_part) }}
  {%- endif -%}

  {%- if los_for_ongoing_encounters is not boolean -%}
    {%- do errors.append("los_for_ongoing_encounters argument must be a boolean (True/False). Got: " ~ los_for_ongoing_encounters) -%}
  {%- endif -%}

  {%- do exceptions.raise_compiler_error("Macro input error(s):\n" ~ errors|join('. \n')) if errors -%}


{#- Macro logic -#}

  {%- if los_for_ongoing_encounters == True -%}
    {%- set snapshot_date = fhir_dbt_utils.get_snapshot_date() -%}

    DATE_DIFF(
      COALESCE( {{ fhir_dbt_utils.string_to_date('period.end') }}, {{snapshot_date}} ),
      {{ fhir_dbt_utils.string_to_date('period.start') }},
      {{date_part}}
  )

  {%- else -%}

    DATE_DIFF(
      {{ fhir_dbt_utils.string_to_date('period.end') }},
      {{ fhir_dbt_utils.string_to_date('period.start') }},
      {{date_part}}
    )

  {%- endif -%}

{%- endmacro -%}