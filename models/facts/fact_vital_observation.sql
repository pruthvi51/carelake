{{ config(
    materialized='table'
) }}

select
    observation_time,
    patient_id,
    encounter_id,
    loinc_code,
    observation_description,
    numeric_value,
    observation_units,
    normal_low,
    normal_high,
    alert_severity
from {{ ref('int_observations_vital_alerts') }}
