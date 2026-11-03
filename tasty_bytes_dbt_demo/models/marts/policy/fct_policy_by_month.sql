with policies as (

    select *
    from {{ ref('int_conformed_policy') }}

),


final as (

    select
        *,
        {{ dbt_utils.generate_surrogate_key(['broker', 'broker_code']) }} as broker_id
    from policies

)

select
    division,
    month,
    year,
    metric,
    state,
    region,
    product,
    program,
    runtime,
    broker_id,
    count(distinct policy_number) as policy_count,
    sum(total_premium) as total_premium
from final
group by all
