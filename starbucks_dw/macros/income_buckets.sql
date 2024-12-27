{% macro income_buckets(income) %}
    case
        when {{ income }} < 20000 then 'Low'
        when {{ income }} between 20000 AND 50000 then 'Medium'
        when {{ income }} > 50000 then 'High'
        else 'Unknown'
    end
{% endmacro %}
