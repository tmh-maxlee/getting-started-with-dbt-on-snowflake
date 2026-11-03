SELECT *
FROM {{ source('tb_101', 'ORDER_DETAIL') }}
{{ limit_rows() }}