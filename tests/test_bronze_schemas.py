from carelake.ingest.schemas import PATIENT_SCHEMA, ENCOUNTER_SCHEMA, CLAIM_SCHEMA

def test_patient_schema_fields():
    fields = {f.name for f in PATIENT_SCHEMA.fields}
    assert "Id" in fields
    assert "BIRTHDATE" in fields
    assert "GENDER" in fields

def test_encounter_schema_fields():
    fields = {f.name for f in ENCOUNTER_SCHEMA.fields}
    assert "Id" in fields
    assert "PATIENT" in fields
    assert "TOTAL_CLAIM_COST" in fields

def test_claim_schema_fields():
    fields = {f.name for f in CLAIM_SCHEMA.fields}
    assert "Id" in fields
    assert "TOTAL_BILLED" in fields
