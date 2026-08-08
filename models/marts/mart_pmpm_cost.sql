{{ config(
    materialized='table',
    schema='gold_marts'
) }}

with monthly_spend as (
    select
        cast(strftime(cast(start_time as date), '%Y-%m-01') as date) as spend_month,
        sum(total_claim_cost) as total_medical_spend,
        count(distinct patient_id) as active_utilizing_members
    from {{ ref('fact_encounter') }}
    group by spend_month
),
total_membership as (
    select count(distinct patient_id) as total_covered_lives from {{ ref('dim_patient') }}
)

select
    s.spend_month,
    s.total_medical_spend,
    s.active_utilizing_members,
    m.total_covered_lives,
    round(s.total_medical_spend / m.total_covered_lives, 2) as pmpm_cost
from monthly_spend s
cross join total_membership m
