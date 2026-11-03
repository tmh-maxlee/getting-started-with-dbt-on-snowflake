SELECT *
FROM {{ source('tb_101', 'MENU') }}
{{ limit_rows() }}