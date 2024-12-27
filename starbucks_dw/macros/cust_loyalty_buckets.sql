{% macro cust_loyalty_buckets(subscribed_date, extraction_date) %}
    case
        when {{ subscribed_date }} >= {{ extraction_date }} - interval '30 days' then 'New Customer'
        when {{ subscribed_date }} < {{ extraction_date }} - interval '2 years' then 'Loyal Customer'
        else 'Recent Customer'
    end
{% endmacro %}
