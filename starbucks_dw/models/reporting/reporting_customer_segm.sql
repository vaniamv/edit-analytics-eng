{{
  config(
    materialized = 'table',
    )
}}

{% set extraction_date = "'2018-07-26'::date"
%}

with customer_responsiveness AS (
    select
        c.customer_id,
        c.gender,
        {{ age_buckets('c.age') }} as age_group,
        {{ cust_loyalty_buckets('c.subscribed_date', extraction_date) }} as customer_loyalty,
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
        c.customer_id, c.gender, age_group, customer_loyalty
)

select
    customer_id,
    gender,
    age_group,
    customer_loyalty,
    response_rate,
    case
        when response_rate > 0.6 THEN 'Highly Responsive'
        when response_rate between 0.3 and 0.59 then 'Moderately Responsive'
        else 'Lowly Responsive'
    end as responsiveness_bucket
from customer_responsiveness
