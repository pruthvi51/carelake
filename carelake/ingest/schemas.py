"""
PySpark Schemas for Bronze Ingestion Quarantine Diverter.
"""
from pyspark.sql.types import (
    StructType, StructField, StringType, DoubleType, IntegerType, TimestampType, DateType
)

PATIENT_SCHEMA = StructType([
    StructField("Id", StringType(), False),
    StructField("BIRTHDATE", DateType(), True),
    StructField("DEATHDATE", DateType(), True),
    StructField("FIRST", StringType(), True),
    StructField("LAST", StringType(), True),
    StructField("GENDER", StringType(), True),
    StructField("RACE", StringType(), True),
    StructField("ETHNICITY", StringType(), True),
    StructField("ADDRESS", StringType(), True),
    StructField("CITY", StringType(), True),
    StructField("STATE", StringType(), True),
    StructField("ZIP", StringType(), True),
])

ENCOUNTER_SCHEMA = StructType([
    StructField("Id", StringType(), False),
    StructField("START", TimestampType(), True),
    StructField("STOP", TimestampType(), True),
    StructField("PATIENT", StringType(), False),
    StructField("ORGANIZATION", StringType(), True),
    StructField("PROVIDER", StringType(), True),
    StructField("PAYER", StringType(), True),
    StructField("ENCOUNTERCLASS", StringType(), True),
    StructField("CODE", StringType(), True),
    StructField("DESCRIPTION", StringType(), True),
    StructField("BASE_ENCOUNTER_COST", DoubleType(), True),
    StructField("TOTAL_CLAIM_COST", DoubleType(), True),
    StructField("PAYER_COVERAGE", DoubleType(), True),
])

CLAIM_SCHEMA = StructType([
    StructField("Id", StringType(), False),
    StructField("PATIENTID", StringType(), False),
    StructField("PROVIDERID", StringType(), True),
    StructField("TOTAL_BILLED", DoubleType(), True),
    StructField("TOTAL_PAID", DoubleType(), True),
    StructField("STATUS", StringType(), True),
])
