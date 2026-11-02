-- Run once as an administrator before the first production build.
-- Existing source data remains in TASTY_BYTES_DBT_DB.RAW.
CREATE DATABASE IF NOT EXISTS edw;
CREATE SCHEMA IF NOT EXISTS edw.bronze;
CREATE SCHEMA IF NOT EXISTS edw.silver;
CREATE SCHEMA IF NOT EXISTS edw.gold;

-- When replacing the tutorial ACCOUNTADMIN production role, grant the chosen
-- role USAGE on EDW, these schemas, and TASTY_BYTES_DBT_WH; read access to RAW;
-- and privileges to create/manage the model objects in each layer (including
-- procedures for Python models). Existing objects may require ownership grants.
