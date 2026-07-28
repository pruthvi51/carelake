{{ config(
    materialized='table',
    contract={'enforced': true}
) }}

select
    patient_id,
    first_name,
    last_name,
    gender,
    race,
    ethnicity,
    birth_date,
    death_date,
    city,
    state,
    zip_code,
    case when death_date is not null then true else false end as is_deceased
from {{ ref('stg_patients') }}
