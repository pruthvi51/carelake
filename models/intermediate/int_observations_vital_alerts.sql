{{ config(
    materialized='table',
    schema='silver_intermediate'
) }}

select
    o.observation_time,
    o.patient_id,
    o.encounter_id,
    o.loinc_code,
    o.observation_description,
    try_cast(o.observation_value as double) as numeric_value,
    o.observation_units,
    r.normal_low,
    r.normal_high,
    case
        when try_cast(o.observation_value as double) < r.normal_low then 'LOW'
        when try_cast(o.observation_value as double) > r.normal_high then 'HIGH'
        else 'NORMAL'
    end as alert_severity
from {{ ref('stg_observations') }} o
inner join {{ ref('loinc_vital_ranges') }} r on o.loinc_code = r.loinc_num
