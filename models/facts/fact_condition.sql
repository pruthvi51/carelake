{{ config(
    materialized='table'
) }}

select
    patient_id,
    encounter_id,
    condition_code,
    condition_description,
    onset_date,
    is_chronic_condition,
    clinical_category
from {{ ref('int_chronic_conditions_flagged') }}
