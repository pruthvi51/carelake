# CareLake Operations Runbook

## 1. Bronze Pipeline Triage
When raw hospital EHR feeds contain corrupted records:
- Check `warehouse/bronze/quarantine` for diverted payloads.
- Review error logs for unmapped ICD-10 or LOINC codes.
- Inspect Dead Letter Queue metrics in Prometheus / Grafana.

## 2. dbt Contract Failure Recovery
If a model contract violation occurs during Gold mart build:
- Verify column datatypes in upstream Silver views against `schema.yml`.
- Re-run dbt compile to identify mismatched nullability constraints.
