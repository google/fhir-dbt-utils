#!/bin/bash

# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -e # Fail on errors.
set -x # Show each command.

# Run with integration_tests project configuration.
cd integration_tests

# Show version and installed adapters.
dbt --version

# Install dbt project dependencies.
dbt deps

# Run all macro unit tests.
dbt run-operation run_unit_tests_cross_db
dbt run-operation run_unit_tests_bigquery
echo "SUCCESS: All tests are passing."

# Remove artifacts on completion.
dbt clean
