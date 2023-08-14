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
    name = "fhir_table_list",
    meta = {
      "description": "List of FHIR resource tables present in the database"
      },
    materialized = 'table'
) -}}

{% if is_spark() %}

  {%- set path_prefix='fhir_resources/' %}
  {%- set fhir_resources={} %}
  {%- for node in graph.nodes.values()
       if node.resource_type == 'model'
       and node.path.startswith(path_prefix)
       and not node.path.endswith('_view.sql') %}
    {%- set fhir_resource = node.path[path_prefix|length : -4] %}
    {%- set table_name = get_source_table_name(fhir_resource) %}
    {%- if adapter.get_relation(
      database = var('database'),
      schema = var('schema'),
      identifier = table_name) %}
      {%- do fhir_resources.update({fhir_resource: table_name}) %}
    {%- endif %}
  {%- endfor %}

  {%- for fhir_resource, table_name in fhir_resources.items() %}
SELECT
  '{{ fhir_resource }}' AS fhir_resource,
  NULL as bq_project,
  NULL as bq_dataset,
  '{{ table_name }}' as bq_table,
  '`{{ var('schema') }}`.`{{ table_name }}`' AS fully_qualified_bq_table,
  NULL AS creation_time
    {% if not loop.last %}UNION ALL{% endif %}
  {% endfor %}

{% else %}

SELECT
  table_catalog as bq_project,
  table_schema as bq_dataset,
  table_name as bq_table,
  CONCAT('`', table_catalog, '`.`', table_schema, '`.`', table_name, '`') AS fully_qualified_bq_table,
  REPLACE(INITCAP(table_name), '_', '') AS fhir_resource,
  creation_time
FROM `{{ var('database') }}`.`{{ var('schema') }}`.INFORMATION_SCHEMA.TABLES

{% endif %}