# FHIR dbt utils

#### **Overview** &nbsp; | &nbsp; [Getting started](readme/getting_started.md) &nbsp; | &nbsp; [Using the package](readme/using_the_package.md) &nbsp; | &nbsp; [Macros](readme/macros.md) &nbsp; | &nbsp; | [Feedback](https://docs.google.com/forms/d/e/1FAIpQLScU0WXCXA7xOX7kGr6QSW9BNMZwHswf5zq10MfRnnZJYQ6L8g/viewform)

---

## What is FHIR-dbt-utils?

FHIR-dbt-utils is a [dbt](https://docs.getdbt.com/docs/introduction) package to support analytics over [FHIR resources]((http://build.fhir.org/resourcelist.html)) stored in BigQuery or Apache Spark.

The package is a foundation on which advanced FHIR analytics can be built. It is predominatly a collection of dbt macros that can be used to:

- Configure dbt sources for your FHIR resource tables
- Make the analysis of complex FHIR fields easier (e.g. codeableConcept fields)
- Provide consistent logic for common healthcare data transformations (e.g. age group bucketing or calculating length of stay)
- Build patient cohorts by combining macros

The macros that you would most likely interact with for analytics are located within the [fhir_analysis_macros](macros/fhir_analysis_macros/) sub-folder. Documentation, including usage examples, can be found in [Using The Package](readme/using_the_package.md).

## Can I make use of this package?

This package is aimed at healthcare analysts, engineers and informaticians using FHIR data for analytics.

The package currently supports FHIR data in the following format:

- ✅ Stored in a supported data warehouse: BigQuery; Spark
- ✅ Conforms to the SQL-based FHIR projections defined by the FHIR community in [SQL-on-FHIR](https://github.com/FHIR/sql-on-fhir/blob/master/sql-on-fhir.md).
- ✅ FHIR version STU3 or R4

## How do I start using it?

You can install fhir-dbt-utils as a package in your own dbt project.

For pre-requisites and step-by-step instructions see the [Getting Started](readme/getting_started.md) tab.

After this, we recommend that you read through [Using The Package](readme/using_the_package.md) to understand how to make use of the macros and other content in your project.

## Support

FHIR-dbt-utils is not an officially supported Google product. The project is work-in-progress so expect additional content to be added as well as potentially breaking changes as we refine the project structure.

If you believe that something’s not working, please [create a GitHub issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/creating-an-issue). We would also very much welcome any general feedback and suggestions for improvements which you can provide via this [Google form](https://docs.google.com/forms/d/e/1FAIpQLScU0WXCXA7xOX7kGr6QSW9BNMZwHswf5zq10MfRnnZJYQ6L8g/viewform).