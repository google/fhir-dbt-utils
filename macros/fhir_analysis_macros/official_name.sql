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

{%- macro official_name(
  include_prefix=True,
  include_suffix=True,
  include_middle_names=True
) -%}

  CONCAT(
  {% if include_prefix == True -%}
    (SELECT ARRAY_TO_STRING(prefix, ' ') FROM UNNEST(name) WHERE use = 'official'), ' ',
  {% endif -%}
  {% if include_middle_names == True -%}
    (SELECT ARRAY_TO_STRING(given, ' ') FROM UNNEST(name) WHERE use = 'official'),
  {% else -%}
    (SELECT given[SAFE_OFFSET(0)] FROM UNNEST(name) WHERE use = 'official'),
  {% endif -%}
    ' ', (SELECT family FROM UNNEST(name) WHERE use = 'official')
  {% if include_suffix == True -%}
    ,' ', (SELECT ARRAY_TO_STRING(suffix, ' ') FROM UNNEST(name) WHERE use = 'official')
  {% endif -%}
  )

{%- endmacro -%}