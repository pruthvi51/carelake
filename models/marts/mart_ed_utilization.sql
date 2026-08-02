{{ config(
    materialized='table',
    schema='gold_marts'
) }}

select
    cast(strftime(cast(start_time as date), '%Y-%m-01') as date) as visit_month,
    count(distinct encounter_id) as ed_visit_count,
    count(distinct patient_id) as unique_patients,
    round(sum(total_claim_cost), 2) as total_ed_spend,
    round(avg(total_claim_cost), 2) as mean_ed_visit_cost
from {{ ref('fact_encounter') }}
where encounter_class = 'EMERGENCY'
group by visit_month
