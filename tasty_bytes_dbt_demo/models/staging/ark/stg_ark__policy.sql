with source as (

    select *
    from {{ source('ark', 'policy') }}

),

renamed as (

    -- POC passthrough: preserve the source grain and all columns.
    -- Replace * with explicit columns, aliases, and casts once reviewed.
    select *
    from source

)

select *
from renamed
