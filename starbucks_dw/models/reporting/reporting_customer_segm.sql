{{
  config(
    materialized = 'table',
    )
}}

{% set extraction_date = "'2018-07-26'::date"
%}
with
    customer_responsiveness as (
        select
            customer_id,
            count(case when transaction_type = 'received' then 1 end) as received_count,
            count(case when transaction_type = 'completed' then 1 end) as completed_count,
            count(case when transaction_type = 'viewed' then 1 end) as viewed_count,
	        count(case when transaction_type = 'transaction' then 1 end) as transaction_count
        from {{ ref('fct_customer_transactions') }}
        group by customer_id
    )

select
    c.gender,
    {{ age_buckets('c.age') }} as age_group,
    {{ income_buckets('c.income') }} as income_bracket,
    avg(case when cr.received_count = 0 then 0 else cr.completed_count * 1.0 / cr.received_count end) as avg_response_rate,
    count(distinct cr.customer_id) as customer_count,
    {{ cust_loyalty_buckets('c.subscribed_date', extraction_date) }} as customer_category
from customer_responsiveness cr
join {{ ref('dim_customer') }} c
    on cr.customer_id = c.customer_id
group by
    c.gender,
    age_group,
    income_bracket,
    customer_category
order by avg_response_rate desc
