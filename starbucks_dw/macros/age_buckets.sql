{% macro age_buckets(age) %}
    case
        when {{ age }} between 18 AND 24 then '18-24'
        when {{ age }} between 25 AND 34 then '25-34'
        when {{ age }} between 35 AND 44 then '35-44'
        when {{ age }} between 45 AND 54 then '45-54'
        when {{ age }} >= 55 then '55+'
        else 'Unknown'
    end
{% endmacro %}
