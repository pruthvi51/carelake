{{ config(
    materialized='table',
    schema='gold_marts'
) }}

select
    c.clinical_category,
    c.condition_description,
    count(distinct c.patient_id) as patient_count,
    round(avg(e.age_at_encounter), 1) as mean_patient_age,
    round(sum(e.total_claim_cost), 2) as total_associated_cost
from {{ ref('fact_condition') }} c
left join {{ ref('fact_encounter') }} e on c.encounter_id = e.encounter_id
where c.is_chronic_condition = 1
group by c.clinical_category, c.condition_description
