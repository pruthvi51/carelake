# ADR 0003: Dimensional Star Schema vs One Big Table (OBT)

## Status: Accepted
## Context
Healthcare queries span both wide longitudinal feature mining and highly targeted point-in-time clinical encounters.

## Decision
Implement Kimball dimensional star schemas (dim_patient, dim_clinical_code, fact_encounter) in Silver, and materialised OLAP marts in Gold.
