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

{{- config(
    name = "encounter_processed",
    meta = {
      "description": "Example query over Encounter FHIR resource",
      "fhir_resource": "Encounter"
      },
    materialized = 'view'
) }}

SELECT
  id AS id,
  subject.patientId AS patient_id,
  class.code AS class,
  {{ code_from_codeableconcept('type', 'http://snomed.info/sct') }} AS type,
  {{ string_to_date('period.start') }} AS period_start,
  {{ string_to_date('period.end') }} AS period_end,
  {{ length_of_stay() }} AS length_of_stay

FROM {{ ref('Encounter') }}
LIMIT 100