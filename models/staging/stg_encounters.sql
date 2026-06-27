{{ config(
    materialized='view',
    schema='silver_staging'
) }}

select
    cast(Id as varchar) as encounter_id,
    cast(START as timestamp) as start_time,
    cast(STOP as timestamp) as stop_time,
    cast(PATIENT as varchar) as patient_id,
    cast(ORGANIZATION as varchar) as organization_id,
    cast(PROVIDER as varchar) as provider_id,
    cast(PAYER as varchar) as payer_id,
    upper(trim(cast(ENCOUNTERCLASS as varchar))) as encounter_class,
    cast(CODE as varchar) as encounter_type_code,
    cast(DESCRIPTION as varchar) as encounter_type_description,
    cast(BASE_ENCOUNTER_COST as double) as base_encounter_cost,
    cast(TOTAL_CLAIM_COST as double) as total_claim_cost,
    cast(PAYER_COVERAGE as double) as payer_coverage,
    round(date_diff('minute', cast(START as timestamp), cast(STOP as timestamp)) / 60.0, 2) as duration_hours
from {{ ref('raw_encounters') if var('use_seed_raw', true) else source('bronze', 'encounters') }}
where Id is not null
