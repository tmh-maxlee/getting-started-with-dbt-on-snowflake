with policies as (

    select *
    from {{ ref('int_conformed_policy') }}

),

final as (

    select
        broker,
        max(broker_code) as broker_code
    from policies
    group by all

)

select
    {{ dbt_utils.generate_surrogate_key(['broker', 'broker_code']) }} as broker_id,
    broker_code,
    broker as broker_name
from final
