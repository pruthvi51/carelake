{{ config(
    materialized='view',
    schema='silver_staging'
) }}

select
    cast(Id as varchar) as patient_id,
    cast(BIRTHDATE as date) as birth_date,
    cast(DEATHDATE as date) as death_date,
    {{ mask_phi('FIRST') }} as first_name_masked,
    {{ mask_phi('LAST') }} as last_name_masked,
    FIRST as first_name,
    LAST as last_name,
    cast(GENDER as varchar) as gender,
    cast(RACE as varchar) as race,
    cast(ETHNICITY as varchar) as ethnicity,
    cast(CITY as varchar) as city,
    cast(STATE as varchar) as state,
    cast(ZIP as varchar) as zip_code
from {{ ref('raw_patients') if var('use_seed_raw', true) else source('bronze', 'patients') }}
where Id is not null
