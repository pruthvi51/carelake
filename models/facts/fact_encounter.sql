{{ config(
    materialized='table'
) }}

select
    encounter_id,
    patient_id,
    encounter_class,
    start_time,
    stop_time,
    age_at_encounter,
    length_of_stay_hours,
    total_claim_cost,
    payer_coverage,
    out_of_pocket_cost
from {{ ref('int_patient_encounters_enriched') }}
