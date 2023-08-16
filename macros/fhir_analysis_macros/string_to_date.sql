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

{%- macro string_to_date(
  date_field,
  timezone=None
) -%}

  {%- if timezone == None -%}
    {%- set timezone = var('timezone_default') -%}
  {%- endif -%}

  IF(
    CHAR_LENGTH({{ date_field }}) = 10,
    {{ fhir_dbt_utils.safe_cast_as_date(date_field) }},
    {{ fhir_dbt_utils.date(
      fhir_dbt_utils.safe_cast_as_timestamp(date_field),
      "'" ~ timezone ~ "'")|indent(8) }}
  )

{%- endmacro -%}