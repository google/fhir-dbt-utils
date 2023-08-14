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

-- depends_on: {{ ref('fhir_table_list') }}

{{- config(
    name = "CareTeam",
    meta = {
      "description": "View of CareTeam FHIR resource",
      "fhir_resource": "CareTeam",
      "metric_date_columns": ["period.start"],
      "patient_reference_column": "subject"
      },
    materialized = 'view'
) -}}

{{ fhir_resource_view_expression() -}}