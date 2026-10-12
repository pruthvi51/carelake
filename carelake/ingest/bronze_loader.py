"""
PySpark Bronze Ingestion Job with Two-Phase Quarantine Error Diverter.
"""
from pathlib import Path
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from carelake.ingest.schemas import PATIENT_SCHEMA, ENCOUNTER_SCHEMA, CLAIM_SCHEMA

__all__ = [
    "create_spark_session",
    "ingest_table_with_quarantine",
    "run_bronze_ingestion",
    "PATIENT_SCHEMA",
    "ENCOUNTER_SCHEMA",
    "CLAIM_SCHEMA",
]

def create_spark_session(app_name: str = "CareLake-BronzeIngest") -> SparkSession:
    return (
        SparkSession.builder
        .appName(app_name)
        .master("local[2]")
        .config("spark.sql.adaptive.enabled", "true")
        .config("spark.sql.shuffle.partitions", "4")
        .getOrCreate()
    )

def ingest_table_with_quarantine(spark: SparkSession, raw_csv_path: Path, output_dir: Path, schema, table_name: str):
    print(f"Ingesting {table_name} from {raw_csv_path}...")
    df = (
        spark.read
        .format("csv")
        .option("header", "true")
        .schema(schema)
        .load(str(raw_csv_path))
    )

    valid_df = df.filter(F.col("Id").isNotNull())
    quarantine_df = df.filter(F.col("Id").isNull())

    valid_count = valid_df.count()
    quarantine_count = quarantine_df.count()

    print(f"Table: {table_name} | Valid: {valid_count} | Quarantined: {quarantine_count}")

    valid_out = output_dir / "valid" / table_name
    valid_df.write.mode("overwrite").parquet(str(valid_out))

    if quarantine_count > 0:
        quarantine_out = output_dir / "quarantine" / table_name
        quarantine_df.write.mode("overwrite").parquet(str(quarantine_out))

    return valid_count, quarantine_count

def run_bronze_ingestion(raw_dir: Path, output_dir: Path, spark: SparkSession | None = None) -> dict:
    """Run full Bronze ingestion pipeline across clinical and claims feeds."""
    should_stop_spark = False
    if spark is None:
        spark = create_spark_session()
        should_stop_spark = True

    try:
        raw_dir = Path(raw_dir)
        output_dir = Path(output_dir)

        # Fallback to seeds if raw_dir doesn't exist
        if not raw_dir.exists():
            seeds_fallback = Path(__file__).resolve().parent.parent.parent / "seeds"
            if seeds_fallback.exists():
                raw_dir = seeds_fallback

        configs = [
            ("patients", ["raw_patients.csv", "patients.csv"], PATIENT_SCHEMA),
            ("encounters", ["raw_encounters.csv", "encounters.csv"], ENCOUNTER_SCHEMA),
            ("claims", ["raw_claims.csv", "claims.csv"], CLAIM_SCHEMA),
        ]

        summary = {}
        for table_name, file_candidates, schema in configs:
            target_file = None
            for cand in file_candidates:
                candidate_path = raw_dir / cand
                if candidate_path.exists():
                    target_file = candidate_path
                    break

            if target_file:
                v_count, q_count = ingest_table_with_quarantine(
                    spark, target_file, output_dir, schema, table_name
                )
                summary[table_name] = {"valid": v_count, "quarantined": q_count}
            else:
                print(f"Skipping {table_name}: no matching CSV found in {raw_dir}")

        return summary
    finally:
        if should_stop_spark:
            spark.stop()

def main():
    import argparse
    parser = argparse.ArgumentParser(description="CareLake PySpark Bronze Ingestion Job")
    parser.add_argument("--raw-dir", default="seeds", help="Directory containing raw clinical CSVs")
    parser.add_argument("--output-dir", default="warehouse/bronze", help="Parquet output directory")
    args = parser.parse_args()

    print(f"Starting CareLake Bronze Ingestion from '{args.raw_dir}' to '{args.output_dir}'...")
    results = run_bronze_ingestion(Path(args.raw_dir), Path(args.output_dir))
    print("CareLake Bronze Ingestion Completed Successfully:")
    for tbl, counts in results.items():
        print(f"  - {tbl}: {counts['valid']} valid, {counts['quarantined']} quarantined")

if __name__ == "__main__":
    main()
