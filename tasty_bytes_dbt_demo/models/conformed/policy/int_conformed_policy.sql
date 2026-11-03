with ark_policies as (

    select *
    from {{ ref('int_ark_policy') }}

),

fine_arts_policies as (

    select *
    from {{ ref('stg_sapiens__policy') }}
),

final as (

    select *
    from ark_policies

    union all

    select *
    from fine_arts_policies

)

select
    * exclude (table_name),
    table_name as metric
from final
