{{ config(
    materialized='view',
    schema='silver_staging'
) }}

select
    cast(Id as varchar) as claim_id,
    cast(PATIENTID as varchar) as patient_id,
    cast(PROVIDERID as varchar) as provider_id,
    cast(TOTAL_BILLED as double) as total_billed,
    cast(TOTAL_PAID as double) as total_paid,
    upper(trim(cast(STATUS as varchar))) as claim_status
from {{ ref('raw_claims') if var('use_seed_raw', true) else source('bronze', 'claims') }}
where Id is not null
