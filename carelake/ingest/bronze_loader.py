"""
PySpark Bronze Ingestion Job with Two-Phase Quarantine Error Diverter.
"""
import os
import sys
from pathlib import Path
from pyspark.sql import SparkSession
from pyspark.sql import functions as F
from carelake.ingest.schemas import PATIENT_SCHEMA, ENCOUNTER_SCHEMA

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

def main():
    print("CareLake Bronze Ingestion Job initialized.")

if __name__ == "__main__":
    main()
