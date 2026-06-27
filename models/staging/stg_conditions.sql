{{ config(
    materialized='view',
    schema='silver_staging'
) }}

select
    cast(START as date) as condition_start_date,
    cast(STOP as date) as condition_stop_date,
    cast(PATIENT as varchar) as patient_id,
    cast(ENCOUNTER as varchar) as encounter_id,
    cast(CODE as varchar) as condition_code,
    cast(DESCRIPTION as varchar) as condition_description
from {{ ref('raw_conditions') if var('use_seed_raw', true) else source('bronze', 'conditions') }}
where PATIENT is not null
