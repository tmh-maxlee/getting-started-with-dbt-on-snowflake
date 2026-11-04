SELECT *
FROM {{ source('tb_101', 'TRUCK') }}
{{ limit_rows() }}

limit 10
