{{ config(
    materialized='table',
    schema='gold_marts'
) }}

with inpatient_encounters as (
    select
        encounter_id,
        patient_id,
        start_time,
        stop_time,
        length_of_stay_hours,
        total_claim_cost,
        lead(start_time) over (partition by patient_id order by start_time) as next_encounter_start
    from {{ ref('fact_encounter') }}
    where encounter_class = 'INPATIENT'
)

select
    encounter_id as index_encounter_id,
    patient_id,
    start_time as index_admission_time,
    stop_time as index_discharge_time,
    next_encounter_start as readmission_admission_time,
    date_diff('day', cast(stop_time as date), cast(next_encounter_start as date)) as days_to_readmission,
    case
        when date_diff('day', cast(stop_time as date), cast(next_encounter_start as date)) between 1 and 30 then 1
        else 0
    end as is_30day_readmission,
    length_of_stay_hours as index_los_hours,
    total_claim_cost as index_cost
from inpatient_encounters
