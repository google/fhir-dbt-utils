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
    name = "observation_processed",
    meta = {
      "description": "Example query over Observation FHIR resource",
      "fhir_resource": "Observation"
      },
    materialized = 'view'
) }}

SELECT
  id AS id,
  {{ code_from_codeableconcept('code', 'http://loinc.org') }} AS loinc_code,
  {{ code_from_codeableconcept('code', 'http://loinc.org', return_field='display') }} AS loinc_display,
  {{ code_from_codeableconcept('category', 'http://hl7.org/fhir/observation-category') }} AS hl7_category,
  {{ has_value('category') }} AS has_category,
  {{ string_to_date('effective.dateTime') }} AS effective_datetime,
  {{ value_from_component('8480-6', 'http://loinc.org') }} AS systolic_bp,
  {{ value_from_component('8462-4', 'http://loinc.org') }} AS diastolic_bp

FROM {{ ref('Observation') }}
LIMIT 100
