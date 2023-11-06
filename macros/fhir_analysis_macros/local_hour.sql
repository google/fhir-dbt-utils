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

{% macro local_hour(date_column, date_column_data_type) -%}

{%- set timezone = "'" ~ var('timezone_default') ~ "'" -%}

{%- if date_column_data_type == 'TIMESTAMP' -%}
    {{ fhir_dbt_utils.timestamp_trunc(
        "hour",
        date_column,
        timezone ) }}
{%- else -%}
    IF(
      CHAR_LENGTH({{ date_column }}) = 10,
      {{ fhir_dbt_utils.safe_cast_as_timestamp('NULL') }},
      {{ fhir_dbt_utils.timestamp_trunc(
          "hour",
          fhir_dbt_utils.safe_cast_as_timestamp(date_column),
          timezone ) }}
    )
{%- endif -%}

{%- endmacro -%}