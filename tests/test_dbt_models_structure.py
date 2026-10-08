from pathlib import Path

def test_model_files_exist():
    root = Path(__file__).parent.parent
    expected = [
        "models/staging/stg_patients.sql",
        "models/staging/stg_encounters.sql",
        "models/dimensions/dim_patient.sql",
        "models/facts/fact_encounter.sql",
        "models/marts/mart_readmission_30d.sql"
    ]
    for path in expected:
        assert (root / path).exists()

def test_seeds_exist():
    root = Path(__file__).parent.parent
    assert (root / "seeds/icd10_codes.csv").exists()
    assert (root / "seeds/loinc_vital_ranges.csv").exists()
    assert (root / "seeds/hedis_measures.csv").exists()
