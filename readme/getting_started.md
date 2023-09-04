# Getting started

#### [Overview](../README.md) &nbsp; | &nbsp; **Getting started** &nbsp; | &nbsp; [Using the package](using_the_package.md) &nbsp; | &nbsp; [Macros](macros.md) &nbsp; | &nbsp; [Feedback](https://docs.google.com/forms/d/e/1FAIpQLScU0WXCXA7xOX7kGr6QSW9BNMZwHswf5zq10MfRnnZJYQ6L8g/viewform)

--------------------------------------------------------------------------------

FHIR-dbt-utils is a dbt package. If you are new to dbt then we reccommend
browsing the dbt online [documentation](https://docs.getdbt.com/) and
[training courses](https://courses.getdbt.com/collections). The following
resources are a good place to start:

-   [What is dbt?](https://docs.getdbt.com/docs/introduction)
-   [What are dbt packages?](https://docs.getdbt.com/docs/build/packages)
-   [Course - dbt Fundamentals](https://courses.getdbt.com/courses/fundamentals)
-   [Quick start guides](https://docs.getdbt.com/quickstarts)

## What you'll need

##### For BigQuery:

-   [dbt BigQuery adapter](https://docs.getdbt.com/reference/warehouse-setups/bigquery-setup)
    1.2.0+ installed on your computer
-   A
    [Google Cloud project](https://cloud.google.com/resource-manager/docs/creating-managing-projects)
    where you have `bigquery.dataEditor` and `bigquery.user` permissions
-   The [gcloud](https://cloud.google.com/sdk/docs/install) command line
    interface for
    [authentication](https://docs.getdbt.com/reference/warehouse-setups/bigquery-setup#local-oauth-gcloud-setup)
-   A [dbt project](https://docs.getdbt.com/docs/build/projects) in which to
    load the fhir-dbt-utils package

##### For Spark:

-   [dbt Spark adapter](https://docs.getdbt.com/reference/warehouse-setups/spark-setup)
    1.2.0+ installed on your computer
-   A Spark installation with a thriftserver running
-   A [dbt project](https://docs.getdbt.com/docs/build/projects) in which to
    load the fhir-dbt-utils package

## Installation instructions

1.  ### Add the package to your dbt project

    Add this package to your `packages.yml` file:

    ```
    packages:
      - package: google/fhir_dbt_utils
        version: 1.0.0
    ```

    If you are unfamiliar with dbt packages then you can learn more
    [here](https://docs.getdbt.com/docs/build/packages).

2.  ### Install the package

    Run the following command in your terminal to install the package:

    ```
    dbt deps
    ```

3.  ### Setup source data

    By default, this package points to source data from the BigQuery
    [Synthea Generated Synthetic Data in FHIR](https://console.cloud.google.com/marketplace/details/mitre/synthea-fhir)
    public dataset. You can test running your project over this dataset by
    leaving the defaults unchanged. To analyze your own data, follow the
    instructions below for your data warehouse.

    ##### BigQuery source data

    You can export data to BigQuery from a Google Cloud FHIR store by following
    the instructions in
    [Storing healthcare data in BigQuery](https://cloud.google.com/architecture/storing-healthcare-data-in-bigquery).
    Once your FHIR data is in BigQuery you can point the
    [project variables](https://docs.getdbt.com/docs/build/project-variables)
    to it by editing the `dbt_project.yml` file:

    -   **database**: The name of a Google Cloud project which contains your
        FHIR BigQuery dataset. For example, *bigquery-public-data*.
    -   **schema**: The name of your FHIR BigQuery dataset. For example,
        *fhir_synthea*.
    -   **timezone_default**: The IANA time-zone name. For example,
        *Europe/London*.

    ##### Spark source data

    You can use the https://github.com/google/fhir-data-pipes project to create
    FHIR data for Spark and point the
    [project variables](https://docs.getdbt.com/docs/build/project-variables)
    to it by editing the `dbt_project.yml` file:

    -   **database**: Leave empty for Spark.
    -   **schema**: The name of your Spark schema. For example, *fhir_synthea*.
