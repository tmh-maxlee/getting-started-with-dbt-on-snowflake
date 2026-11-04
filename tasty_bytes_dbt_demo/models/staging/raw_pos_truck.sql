SELECT *
FROM {{ source('tb_101', 'TRUCK') }}
limit 10
