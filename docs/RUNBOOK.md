# CareLake Operational Runbook & Incident Response Manual

This document details operational triage protocols, incident response playbooks, and disaster recovery procedures for the CareLake Medallion Lakehouse platform.

---

## Playbook 1: Bronze Dead-Letter Quarantine Triage & Schema Drift

### Severity: High (Pipeline Degraded)
**Symptom:** Upstream EHR/claims ingestion reports quarantined records in `warehouse/bronze/quarantine/<table_name>`.

### Triage Steps:
1. **Locate Quarantined Payloads:**
   ```bash
   ls -lh warehouse/bronze/quarantine/
   ```
2. **Inspect Malformed Partitions:**
   Query quarantined Parquet files directly via DuckDB to inspect the error mode:
   ```sql
   select Id, BIRTHDATE, FIRST, LAST, count(*)
   from read_parquet('warehouse/bronze/quarantine/patients/*.parquet')
   group by all;
   ```
3. **Determine Cause:**
   - **Case A: Null Primary Key (`Id is null`).** Upstream hospital interface engine omitted unique patient or encounter identifier. Route back to provider integration contact.
   - **Case B: Timestamp Format Mutation.** Upstream feed changed datetime format (e.g., ISO-8601 to US standard `MM/DD/YYYY HH:MM:SS`). Update Spark reading options in `carelake/ingest/bronze_loader.py`.
   - **Case C: Unmapped Terminology.** Raw records contain non-standard local billing codes. Add mappings to `seeds/icd10_codes.csv` or `seeds/loinc_vital_ranges.csv`.
4. **Reprocess Quarantined Data:**
   After applying the fix, re-ingest clean records:
   ```bash
   carelake ingest --raw-dir warehouse/bronze/quarantine/corrected --output-dir warehouse/bronze
   ```

---

## Playbook 2: HIPAA PHI De-Identification Audit & Salt Rotation

### Severity: Critical (Compliance / Legal)
**Symptom:** Periodic HIPAA compliance audit, or necessity to rotate secret salts used for dynamic SHA-256 pseudonymization.

### Protocol:
1. **Zero Raw PHI in Silver/Gold:**
   Verify that direct identifiers (`FIRST`, `LAST`, `ADDRESS`) are masked across all downstream analytical models:
   ```sql
   -- Verify absence of unmasked names in dim_patient
   select * from dim_patient where first_name not like 'Patient_%' and first_name not like '%\_%' limit 5;
   ```
2. **Salt Rotation Procedure:**
   - Salts are declared in `macros/mask_phi.sql`.
   - To rotate salts (e.g. from `_CARELAKE_SALT_2026` to `_CARELAKE_SALT_2027`), update the macro salt constant.
   - Trigger a full refresh rebuild of all Silver and Gold models to align hashes across historical tables:
   ```bash
   dbt run --full-refresh
   ```
3. **Audit Trail Verification:**
   Confirm that all derived hash lengths equal 64 characters (SHA-256 hexadecimal output).

---

## Playbook 3: dbt Contract Violations & Schema Breaking Changes

### Severity: Medium (Model Compilation Failure)
**Symptom:** `dbt build` fails with `Contract Error in model <model_name>`.

### Triage Steps:
1. **Identify Constraint Mismatch:**
   Review `schema.yml` against the compiled SQL output in `target/compiled/carelake/models/...`.
2. **Common Contract Violations:**
   - **Nullability Constraint:** A column declared `data_type: varchar, constraints: [{type: not_null}]` received null values from an outer join.
   - **Remedy:** Wrap calculation in `coalesce(...)` or enforce an inner join with the master dimension.
   - **Type Mismatch:** Floating-point claim cost received integer from upstream. Enforce explicit `cast(... as double)`.
3. **Test Compilation:**
   ```bash
   pytest -v tests/test_dbt_models_structure.py
   ```

---

## Playbook 4: CMS HRRP Readmission Metric Variance & Discrepancy Auditing

### Severity: Medium (Clinical Reporting Anomaly)
**Symptom:** Clinical quality team reports 30-day readmission rate discrepancy exceeding $\pm 2.0\%$ compared to CMS claims files.

### Triage Steps:
1. **Inspect Readmission Delta Windows:**
   ```sql
   select
       days_to_readmission,
       count(*) as encounter_count
   from mart_readmission_30d
   group by days_to_readmission
   order by days_to_readmission;
   ```
2. **Verify Index Discharge Criteria:**
   Ensure same-day transfers (e.g. `days_to_readmission = 0`) are excluded from readmission penalties, adhering strictly to CMS HRRP guidelines (`between 1 and 30 days`).
3. **Audit Cross-Facility Patient Linkage:**
   Check whether patients admitted under alternate facility identifiers have conformed linkage via `patient_id`.

---

## Playbook 5: Storage Compaction & Vacuuming

### Severity: Low (Maintenance)
**Symptom:** DuckDB database file fragmentation or excessive small Parquet files in `warehouse/bronze/valid/`.

### Maintenance Commands:
```sql
-- DuckDB storage defragmentation
checkpoint;
vacuum;
```
For Apache Iceberg / Parquet directories:
Execute file compaction on partitions exceeding 100 small files to optimize columnar scan performance.
