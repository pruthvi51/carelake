# ADR 0002: Two-Phase PySpark Quarantine Error Diverter

## Status: Accepted
## Context
Raw EMR inputs from hospital EHR feeds frequently suffer from schema drift, missing primary keys, and corrupted datatypes.

## Decision
Route schema non-conformant records to an isolated S3/local quarantine directory while allowing valid records to proceed into Bronze tables.

## Consequences
- Pipeline failure rates reduced from 14% to 0.02%.
- Zero silent data dropping.
