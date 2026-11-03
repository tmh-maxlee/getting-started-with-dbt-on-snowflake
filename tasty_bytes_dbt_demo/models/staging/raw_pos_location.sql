SELECT *
FROM {{ source('tb_101', 'LOCATION') }}
{{ limit_rows() }}