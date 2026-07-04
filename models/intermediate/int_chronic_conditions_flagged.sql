{{ config(
    materialized='table',
    schema='silver_intermediate'
) }}

select
    c.patient_id,
    c.encounter_id,
    c.condition_code,
    c.condition_description,
    c.condition_start_date as onset_date,
    coalesce(ref.chronic_condition_flag, 0) as is_chronic_condition,
    coalesce(ref.category, 'Uncategorized') as clinical_category
from {{ ref('stg_conditions') }} c
left join {{ ref('icd10_codes') }} ref on c.condition_code = ref.code
