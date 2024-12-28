{{
  config(
    materialized = 'table',
    )
}}

with customer_responsiveness AS (
    select
        c.customer_id,
        of.offer_channel,
        {{ calculate_response_rate('t.transaction_type', 'of.offer_transaction_key') }} as response_rate
    from
        {{ ref('dim_customer') }} c
    left join
        {{ ref('fct_customer_transactions') }} t
        on c.customer_id = t.customer_id
    left join
        {{ ref('fct_offer_transactions') }} of
        on t.transaction_id = of.transaction_id
    group by
        c.customer_id, of.offer_channel
)

select
    offer_channel,
    round(avg(response_rate),2) as avg_response_rate_per_channel
from customer_responsiveness
group by offer_channel
order by avg_response_rate_per_channel desc
