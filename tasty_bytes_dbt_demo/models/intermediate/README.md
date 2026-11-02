# Intermediate models

Place reusable intermediate transformations (`int_*.sql`) in this directory.
They are configured as views in `EDW.SILVER` for target `prod`, and in
`TASTY_BYTES_DBT_DB.DEV_<username>_SILVER` for target `dev`.

Use `ref()` to connect staging, intermediate, and mart models across schemas.
There are no intermediate models yet; dbt may report the corresponding model
configuration as unused until the first SQL model is added here.
