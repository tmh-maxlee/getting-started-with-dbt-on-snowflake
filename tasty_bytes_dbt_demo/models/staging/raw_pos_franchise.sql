SELECT *
FROM {{ source('tb_101', 'FRANCHISE') }}
{{ limit_rows() }}