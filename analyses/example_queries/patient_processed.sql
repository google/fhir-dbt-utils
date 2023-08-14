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
    name = "patient_processed",
    meta = {
      "description": "Example query over Patient FHIR resource",
      "fhir_resource": "Patient"
      },
    materialized = 'view'
) }}

SELECT
  id AS id,
  {{ identifier('http://hl7.org/fhir/sid/us-ssn') }} AS ssn,
  {{ official_name() }} AS official_name,
  {{ full_address() }} AS full_address,
  {{ has_value('birthDate') }} AS has_value_birthdate,
  {{ age() }} AS age,
  {{ bucket(age()) }} AS age_group,
  {{ alive() }} AS is_alive

FROM {{ ref('Patient') }}
LIMIT 100