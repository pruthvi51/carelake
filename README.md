# CareLake: Healthcare Medallion Lakehouse

Production-grade, contract-enforced Medallion Lakehouse architecture engineering longitudinal clinical and claims data into high-performance analytical data products using **PySpark Bronze Ingestion**, **Apache Iceberg**, **dbt-DuckDB / Snowflake**, and **MetricFlow**.

[![CI](https://github.com/pruthvi51/carelake/actions/workflows/ci.yml/badge.svg)](https://github.com/pruthvi51/carelake/actions/workflows/ci.yml)
[![Technical Paper](https://img.shields.io/badge/paper-PDF-red.svg)](paper/carelake_technical_report.pdf)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

## Architecture Overview
```
           +-------------------------------------------------------------+
           |                 CareLake Medallion Architecture             |
           +-------------------------------------------------------------+
                                          |
    +-------------------------------------+-------------------------------------+
    |                                     |                                     |
    v                                     v                                     v
[ Bronze Layer ]                   [ Silver Layer ]                      [ Gold Layer ]
* Raw Synthea EMR & Claims         * De-identified Staging Views         * Clinical Marts (LOS, 30d Readmit)
* PySpark Ingestion Engine         * Conformed Dimensions & Facts        * Contract-Enforced Marts
* Quarantine Error Diverter        * MetricFlow Semantic Layer           * Sub-second BI Query Engine
```
