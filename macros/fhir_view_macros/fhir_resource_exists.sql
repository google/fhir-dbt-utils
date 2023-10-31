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

{%- macro fhir_resource_exists(test_fhir_resource) -%}

    {%- if var('assume_resources_exist') -%}
        {{ return (True) }}
    {%- endif -%}

  {# Query all available FHIR resources #}
  {% set resource_list =
      dbt_utils.get_column_values(table=ref('fhir_table_list'), column='fhir_resource') %}

  {# Check for resource of interest #}
  {% for resource in resource_list %}
     {% if resource == test_fhir_resource %}
        {{ return(True) }}
     {% endif %}
  {% endfor %}

  {{ return(False) }}

{% endmacro %}