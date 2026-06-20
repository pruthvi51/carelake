{{ config(
    materialized='view',
    schema='silver_staging'
) }}

select
    cast(START as timestamp) as medication_start_time,
    cast(STOP as timestamp) as medication_stop_time,
    cast(PATIENT as varchar) as patient_id,
    cast(ENCOUNTER as varchar) as encounter_id,
    cast(CODE as varchar) as rxnorm_code,
    cast(DESCRIPTION as varchar) as medication_description,
    cast(TOTALCOST as double) as medication_cost
from {{ ref('raw_medications') if var('use_seed_raw', true) else source('bronze', 'medications') }}
where PATIENT is not null
