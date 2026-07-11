{{ config(
    materialized='table',
    schema='silver_intermediate'
) }}

select
    e.encounter_id,
    e.start_time,
    e.stop_time,
    e.patient_id,
    e.encounter_class,
    e.encounter_type_code,
    e.encounter_type_description,
    e.total_claim_cost,
    e.payer_coverage,
    round(e.total_claim_cost - coalesce(e.payer_coverage, 0), 2) as out_of_pocket_cost,
    p.gender,
    p.race,
    p.ethnicity,
    p.birth_date,
    round(date_diff('year', p.birth_date, cast(e.start_time as date)), 1) as age_at_encounter,
    e.duration_hours as length_of_stay_hours
from {{ ref('stg_encounters') }} e
inner join {{ ref('stg_patients') }} p on e.patient_id = p.patient_id
