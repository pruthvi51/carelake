# ADR 0004: Dynamic Column-Level PHI Masking for HIPAA Compliance

## Status: Accepted
## Context
HIPAA Safe Harbor mandates de-identification of 18 direct identifiers before analytical consumption.

## Decision
Implement cryptographic SHA-256 salted hashing macros in dbt for patient names and addresses, executed at the view boundary.
