# ADR 0001: Apache Iceberg as Primary Storage Format for Lakehouse Tables

## Status: Accepted
## Context
Longitudinal clinical telemetry requires ACID transactions, time travel queries for audit trails, and partition evolution without data restatement.

## Decision
Adopt Apache Iceberg on Parquet storage for Bronze and Silver layers, queried natively via DuckDB and PySpark.

## Consequences
- Guaranteed atomicity across concurrent ingestion jobs.
- Zero-copy snapshot isolation for reproducible research evaluations.
