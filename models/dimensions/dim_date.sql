{{ config(
    materialized='table'
) }}

with recursive date_series as (
    select cast('2020-01-01' as date) as date_day
    union all
    select date_day + interval '1 day'
    from date_series
    where date_day < cast('2027-12-31' as date)
)

select
    date_day,
    year(date_day) as year_num,
    month(date_day) as month_num,
    quarter(date_day) as quarter_num,
    day(date_day) as day_num,
    strftime(date_day, '%A') as day_name,
    case when dayofweek(date_day) in (0, 6) then true else false end as is_weekend
from date_series
