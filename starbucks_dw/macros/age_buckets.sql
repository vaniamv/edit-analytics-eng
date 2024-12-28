{% macro age_buckets(age) %}
    case
        when {{ age }} between 18 AND 34 then 'Young Adult'
        when {{ age }} between 35 AND 44 then 'Adult'
        when {{ age }} between 45 AND 59 then 'Senior Adult'
        when {{ age }} >= 60 then 'Elder'
        else 'Unknown'
    end
{% endmacro %}
