{% macro mask_phi(column_name) %}
    case
        when {{ column_name }} is null then null
        else sha256(concat(cast({{ column_name }} as varchar), '_CARELAKE_SALT_2026'))
    end
{% endmacro %}
