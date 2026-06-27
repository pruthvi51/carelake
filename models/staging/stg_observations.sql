{{ config(
    materialized='view',
    schema='silver_staging'
) }}

select
    cast(DATE as timestamp) as observation_time,
    cast(PATIENT as varchar) as patient_id,
    cast(ENCOUNTER as varchar) as encounter_id,
    cast(CODE as varchar) as loinc_code,
    cast(DESCRIPTION as varchar) as observation_description,
    cast(VALUE as varchar) as observation_value,
    cast(UNITS as varchar) as observation_units
from {{ ref('raw_observations') if var('use_seed_raw', true) else source('bronze', 'observations') }}
where PATIENT is not null
