{% macro calculate_response_rate(transaction_status, offer_id, status='completed') %}
   round(
    coalesce(
        COUNT(DISTINCT CASE WHEN {{ transaction_status }} = '{{ status }}' THEN {{ offer_id }} END) * 1.0
        / NULLIF(COUNT(DISTINCT {{ offer_id }}), 0),
        0),
    2)

{% endmacro %}
