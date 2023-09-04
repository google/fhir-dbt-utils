# Macros

#### [Overview](../README.md) &nbsp; | &nbsp; [Getting started](getting_started.md) &nbsp; | &nbsp; [Using the package](using_the_package.md) &nbsp; | &nbsp; **Macros** &nbsp; | &nbsp; [Feedback](https://docs.google.com/forms/d/e/1FAIpQLScU0WXCXA7xOX7kGr6QSW9BNMZwHswf5zq10MfRnnZJYQ6L8g/viewform)

--------------------------------------------------------------------------------

## age ([source](../macros/fhir_analysis_macros/age.sql))

Prints SQL to calculate a patient's age on a specific date from their date of
birth, returning an integer.

The date on which to calculate age is selected in the following priority order:

1.  The `snapshot_date` argument provided to this macro, if specified.
2.  The `snapshot_date` project variable, if specified.
3.  Today's date.

**Arguments**

-   **`date_of_birth_field`** (optional): Field containing the patient's date of
    birth. Default argument is the `birthDate` field from the Patient FHIR
    resource.
-   **`snapshot_date`** (optional): Date on which to calculate patient age.

**Example use**

Default arguments:

```sql
SELECT {{ fhir_dbt_utils.age() }} AS age
FROM {{ ref('Patient') }}
```

Calculate age on a specific date:

```sql
SELECT {{ fhir_dbt_utils.age(snapshot_date="2023-01-01") }} AS age
FROM {{ ref('Patient') }}
```

Use macro when date of birth is recorded in a field other than `birthdate`:

```sql
SELECT {{ fhir_dbt_utils.age(date_of_birth_field="dob") }} AS age
FROM {{ ref('my_processed_table_with_dob_field') }}
```

## alive ([source](../macros/fhir_analysis_macros/alive.sql))

Prints SQL to evaluate whether a patient was alive on a given date, returning a
boolean.

The date on which to evaluate is selected in the following priority order:

1.  The `snapshot_date` argument provided to this macro, if specified.
2.  The `snapshot_date` project variable, if specified.
3.  Today's date.

**Arguments**

-   **`date_of_death_field`** (optional): Field containing the patient's date of
    death. Default argument is the `deceased.dateTime` field from the Patient
    FHIR resource.
-   **`snapshot_date`** (optional): Date on which to evaluate whether a patient
    was alive.

**Example use:**

Default arguments:

```sql
SELECT {{ fhir_dbt_utils.alive() }} AS is_alive
FROM {{ ref('Patient') }}
```

Evaluate whether patient was alive on a specific date:

```sql
SELECT {{ fhir_dbt_utils.alive(snapshot_date="2023-01-01") }} AS is_alive
FROM {{ ref('Patient') }}
```

Use macro when date of death is recorded in a field other than
`deceased.dateTime`:

```sql
SELECT {{ fhir_dbt_utils.alive(date_of_death_field="dod") }} AS is_alive
FROM {{ ref('my_processed_table_with_dod_field') }}
```

## bucket ([source](../macros/fhir_analysis_macros/bucket.sql))

Prints SQL to group values within a numerical field into ordinal buckets,
returning a string denoting the bucket range (e.g. "10 - 20").

**Arguments**

-   **`field`** (required): Field containing numerical values to be grouped.
-   **`boundaries_array`** (optional): List of numbers to be the boundaries for
    bucketing. For example, "[1, 5, 10]" would group values into the following
    buckets: "< 1", "1 - 5", "5 - 10", ""> 10". The default is [00, 10, 20, 30,
    40, 50, 60, 70, 80, 90, 100].

**Example use:**

Bucket patients into age groups by wrapping around the `age` macro:

```sql
SELECT {{ fhir_dbt_utils.bucket(fhir_dbt_utils.age()) }} AS age_group
FROM {{ ref('Patient') }}
```

Set custom age group ranges:

```sql
SELECT {{ fhir_dbt_utils.bucket(fhir_dbt_utils.age(), boundaries_array=[00, 18, 65]) }} AS age_group
FROM {{ ref('Patient') }}
```

## code_from_codeableconcept ([source](../macros/fhir_analysis_macros/code_from_codeableconcept.sql))

Prints SQL to extract a code for a specified code system from a FHIR
codeableConcept field.

If `coding.code` is not informative, then can return `coding.display` instead by
setting the `return_field` argument to 'display'.

**Arguments**

-   **`field_name`** (required): FHIR field that is of type codeableConcept. If
    this field in an array, then the macro will unnest this field.
-   **`code_system`** (required): Coding system to filter the search of the
    codeableConcept field.
-   **`fhir_resource`** (optional): The FHIR resource to check whether the
    specified `field_name` exists. If not specified, the macro will default to
    using the `primary_resource` speficied in the model metadata.
-   **`return_field`** (optional): If set to 'display', the macro will return
    the `coding.display` field from the codeableConcept. By default,
    `coding.code` will be returned.
-   **`is_array`** (optional): Whether the top level FHIR field (specified by
    the `field_name` argument) is an array. If set to True, the macro will
    unnest this field. If this argument is not provided, the macro will
    determine whether the field in an array using the `field_is_array` macro.
    This argument only needs to be provided during testing.

**Example use:**

Extract Loinc codes from `Observation.code` codeableConcept field.

```sql
SELECT
  {{ fhir_dbt_utils.code_from_codeableconcept('code', 'http://loinc.org') }} AS loinc_code,
  {{ fhir_dbt_utils.code_from_codeableconcept('code', 'http://loinc.org', return_field='display') }} AS loinc_display
FROM {{ ref('Observation') }}
```

Filter Observation table to observations with a specific Loinc code:

```sql
SELECT *
FROM {{ ref('Observation') }}
WHERE "8480-6" IN ({{ fhir_dbt_utils.code_from_codeableconcept('code', 'http://loinc.org') }})
```

## full_address ([source](../macros/fhir_analysis_macros/full_address.sql))

Prints SQL for extracting a full address string from the `address` FHIR field.
For example: *"615 Synthea Lane, Suite 4, Boston, Massachusetts, 02111, US"*

The macro preferentially extracts a home address if recorded (`address.use` =
"home").

**Example use:**

Extract full address for a patient:

```sql
SELECT {{ fhir_dbt_utils.full_address() }} AS full_address
FROM {{ ref('Patient') }}
```

## has_value ([source](../macros/fhir_analysis_macros/has_value.sql))

Prints SQL for evaluating whether a field has a value recorded, returning TRUE
if it does and FALSE if does not.

A field is evaluated as not recorded if it is NULL or contains a value matching
any value within the `null_values` list argument.

**Arguments**

-   **`field_name`** (required): FHIR field to evaluate.
-   **`null_values`** (optional): List of string values considered as NULL. If
    `field_name` matches any of these values, the SQL will return FALSE.
    Default; `null_values` project variable.

**Example use:**

Calculate the proportion of observations that have a `category` recorded:

```sql
SELECT
  COUNT(*) AS count_observations,
  SUM(IF({{ fhir_dbt_utils.has_value('category') }} = TRUE, 1, 0) AS count_observations_with_category,
  SAFE_DIVIDE(SUM(IF({{ fhir_dbt_utils.has_value('category') }} = TRUE, 1, 0), COUNT(*)) AS proportion_observations_with_category
FROM {{ ref('Observation') }}
```

## identifier ([source](../macros/fhir_analysis_macros/identifier.sql))

Prints SQL to return an identifier value for a specified system from a FHIR
identifier field.

**Arguments**

-   **`system`** (required): Identifier system for which to return the
    identifier. For example: "http://hl7.org/fhir/sid/us-ssn".

**Example use:**

Extract social security number from the `Patient.identifier` field:

```sql
SELECT {{ fhir_dbt_utils.identifier('http://hl7.org/fhir/sid/us-ssn') }} AS ssn
FROM {{ ref('Patient') }}
```

## length_of_stay ([source](../macros/fhir_analysis_macros/length_of_stay.sql))

Prints SQL for calculating the length of stay for an encounter from the
`Encounter.period` FHIR field.

**Arguments**

-   `date_part` (optional): The date unit for which to calculate length of stay.
    Default; DAY. Accecpted values: DAY, WEEK, MONTH, QUARTER, YEAR.
-   `los_for_ongoing_encounters` (optional): Whether to calculate length of stay
    for encounters that are still ongoing (`period.end` is NULL). For such
    encounters, the length of stay is calculated from the `period.start` date to
    the `snapshot_date` project variable or to today's date if `snapshot_date`
    is not set. Default; False.

**Example use:**

Calculate encounter length of stay in days:

```sql
SELECT {{ fhir_dbt_utils.length_of_stay() }} AS length_of_stay
FROM {{ ref('Encounter') }}
```

Calculate encounter length of stay in days including length of stay to-date for
ongoing encounters:

```sql
SELECT {{ fhir_dbt_utils.length_of_stay(los_for_ongoing_encounters=True) }} AS length_of_stay
FROM {{ ref('Encounter') }}
```

## official_name ([source](../macros/fhir_analysis_macros/official_name.sql))

Prints SQL for extracting a full official name from the `name` FHIR field.

**Arguments**

-   **`include_prefix`** (optional): Whether to include prefixes (e.g. "Mrs") in
    the returned name. Default; True.
-   **`include_suffix`** (optional): Whether to include suffixes (e.g. "Jr") in
    the returned name. Default; True.
-   **`include_middle_names`** (optional): Whether to include middle names in
    the returned name. Default; True.

**Example use:**

Extract official name for a patient:

```sql
SELECT {{ fhir_dbt_utils.official_name() }} AS official_name
FROM {{ ref('Patient') }}
```

Extract name without prefix, suffix and middle names:

```sql
SELECT {{ fhir_dbt_utils.official_name(include_prefix=False, include_suffix=False, include_middle_names=False) }} AS official_name
FROM {{ ref('Patient') }}
```

## string_to_date ([source](../macros/fhir_analysis_macros/string_to_date.sql))

Prints SQL for returning the local date from a field containing a date or
datetime stored as a string.

**Arguments**

-   **`date_field`** (required): Field containing dates or datetimes stored as
    strings.
-   **`timezone`** (optional): The IANA time-zone name for this data. For
    example, "Europe/London". Defaults to the `timezone_default` project
    variable if not set.

**Example use:**

Extract Encounter discharge date in the local timezone.

```sql
SELECT {{ string_to_date('period.end') }} AS period_end
FROM {{ ref('Encounter') }}
```

## value_from_component ([source](../macros/fhir_analysis_macros/value_from_component.sql))

Prints SQL to extract a value from the FHIR `Observation.component` field.

**Arguments**

-   **`code`** (required): The code for which to return a value.
-   **`code_system`** (required): The code system that the code specified
    belongs to.
-   **`return_field`** (optional): The value sub-field to return. Default;
    `quantity.value`.

**Example use:**

Extract systolic and diastolic blood pressure values from the `component` field
within the Observation resource:

```sql
SELECT
  {{ value_from_component('8480-6', 'http://loinc.org') }} AS systolic_bp,
  {{ value_from_component('8462-4', 'http://loinc.org') }} AS diastolic_bp
FROM {{ ref('Observation') }}
```
