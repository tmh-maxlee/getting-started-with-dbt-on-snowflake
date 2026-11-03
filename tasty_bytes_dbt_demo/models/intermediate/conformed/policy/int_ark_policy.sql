with ark_policies as (

    select *
    from {{ ref('stg_ark__policy') }}

),

ark_bdx_policies as (

    select *
    from {{ ref('stg_ark__policy_bdx') }}

),

final as (

    select *
    from ark_policies

    union all

    select *
    from ark_bdx_policies

)

select *
from final