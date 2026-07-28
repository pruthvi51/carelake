{{ config(
    materialized='table'
) }}

select
    code as clinical_code,
    description as code_description,
    category as organ_system_category,
    case when chronic_condition_flag = 1 then true else false end as is_chronic_flag
from {{ ref('icd10_codes') }}
