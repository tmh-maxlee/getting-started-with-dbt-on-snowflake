SELECT *
FROM {{ source('tb_101', 'COUNTRY') }}
{{ limit_rows() }}