{{
  config(
    materialized = 'table',
    )
}}

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
    case
        when c.age between 18 AND 24 then '18-24'
        when c.age between 25 AND 34 then '25-34'
        when c.age between 35 AND 44 then '35-44'
        when c.age between 45 AND 54 then '45-54'
        when c.age >= 55 then '55+'
        else 'Unknown'
    end as age_group,
    case
        when c.income < 20000 then 'Low'
        when c.income between 20000 AND 50000 then 'Medium'
        when c.income > 50000 then 'High'
        else 'Unknown'
    end as income_bracket,
    avg(case when cr.received_count = 0 then 0 else cr.completed_count * 1.0 / cr.received_count end) as avg_response_rate,
    count(distinct cr.customer_id) as customer_count
from customer_responsiveness cr
join {{ ref('dim_customer') }} c
    on cr.customer_id = c.customer_id
group by
    c.gender,
    age_group,
    income_bracket
order by avg_response_rate desc
