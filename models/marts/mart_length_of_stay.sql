{{ config(
    materialized='table',
    schema='gold_marts'
) }}

select
    encounter_class,
    count(distinct encounter_id) as total_encounters,
    round(avg(length_of_stay_hours), 2) as mean_los_hours,
    round(median(length_of_stay_hours), 2) as median_los_hours,
    round(avg(total_claim_cost), 2) as mean_encounter_cost,
    round(sum(total_claim_cost), 2) as aggregate_cost
from {{ ref('fact_encounter') }}
group by encounter_class
