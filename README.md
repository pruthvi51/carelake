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

## Research Paper & Citation
The full 6-page IEEE technical report is available at [paper/carelake_technical_report.pdf](paper/carelake_technical_report.pdf).

```bibtex
@article{gattu2026carelake,
  author = {Gattu, Pruthvi Nag},
  title = {CareLake: Engineering a Governed, Contract-Enforced Medallion Lakehouse for Enterprise Clinical Telemetry},
  journal = {Technical Report},
  year = {2026},
  url = {https://github.com/pruthvi51/carelake}
}
```
