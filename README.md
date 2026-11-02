# Getting Started with dbt Projects on Snowflake

## Overview

This repository contains an example dbt project for [dbt Projects on Snowflake](https://docs.snowflake.com/en/user-guide/data-engineering/dbt-projects-on-snowflake). It uses the fictitious **Tasty Bytes** food truck brand as sample data and walks through environment setup, data modeling, CI/CD, and scheduling — all running natively inside Snowflake.

This repository is based on these Snowflake tutorials:
- [Get started with dbt Projects on Snowflake](https://docs.snowflake.com/en/user-guide/tutorials/dbt-projects-on-snowflake-getting-started-tutorial)
- [Set up CI/CD for dbt Projects on Snowflake](https://docs.snowflake.com/en/user-guide/tutorials/dbt-projects-on-snowflake-ci-cd-tutorial)

## What's Included

### Setup Scripts (`setup/`)

- **`tasty_bytes_setup.sql`** — Creates the warehouse, database, schemas, GitHub integration, network rules, and loads the Tasty Bytes source data from S3 into raw tables.
- **`ci_cd_setup.sql`** — Creates a GitHub Actions service user with OIDC authentication and optional network policies for CI/CD pipelines.

### dbt Project (`tasty_bytes_dbt_demo/`)

- **Staging models** — Views that clean and rename columns from raw source tables (orders, trucks, menus, locations, franchises, customer loyalty).
- **Mart models** — Tables that aggregate business metrics: `orders`, `customer_loyalty_metrics`, and `sales_metrics_by_location` (Python model).
- **Custom macros** — Schema name generation for multi-environment deployments (dev/prod).
- **Generic tests** — Reusable test for validating positive amounts.

### CI/CD (`.github/workflows/`)

- **`incoming_pr.yml`** — Runs dbt checks against a dev environment when a PR is opened.
- **`pr_merged.yml`** — Deploys the dbt project to production when a PR is merged.

### Scheduling (`schedules.sql`)

Task definitions for running the dbt project on a schedule using Snowflake Tasks.

## Quick Start

1. Fork this repository.
2. Run `tasty_bytes_dbt_demo/setup/tasty_bytes_setup.sql` in a Snowflake worksheet to create the environment and load source data.
3. Create a [workspace in Snowsight](https://docs.snowflake.com/en/user-guide/ui-snowsight/workspaces) connected to your fork.
4. Follow the developer setup below, then run `dbt deps` and `dbt build --target dev` from the workspace.

## Developer environments (two-developer POC)

Each developer uses their own Snowflake login and workspace, with the same `dev`
profile target. Snowflake resolves `tasty_bytes_dbt_demo/env.yml` before dbt starts:

| Variable | Value |
| --- | --- |
| `DBT_DEV_SCHEMA` | `DBT_<sanitized username>_<8-character username hash>` |
| `DBT_DEV_ROLE` | The active Snowflake session role |

For example, users `ALICE` and `BOB` automatically receive different schemas in
`TASTY_BYTES_DBT_DB`. No developer names or credentials need to be committed, and
adding another developer does not require a configuration change. The hash avoids
ordinary collisions when punctuation in usernames is replaced with underscores.
Use separate Snowflake users; sharing a login also shares the development schema.

1. Select your development role and `TASTY_BYTES_DBT_WH` in your Snowflake workspace.
2. Open the `tasty_bytes_dbt_demo` project and use target `dev` (the default).
   The default environment in `env.yml` is also `dev`; environment selection and
   dbt target selection are separate settings.
3. Run `dbt deps`, then `dbt compile --target dev`, and inspect the generated model
   relations to confirm your personal schema before running `dbt build --target dev`.

An administrator must grant the development role warehouse `USAGE`, database
`USAGE`, `USAGE` on `RAW`, and `SELECT` on its source tables. To let dbt create its
schemas, the role also needs `CREATE SCHEMA` on `TASTY_BYTES_DBT_DB`. Alternatively,
have an administrator precreate each personal schema and grant the developer role
the ownership/creation privileges needed for its dbt models (including Python
model procedures). Prefer a development role over the tutorial's `ACCOUNTADMIN`.
Shared roles provide naming isolation, not access isolation; use separate roles
and schema grants if developers must be prevented from modifying each other's data.

Sources continue to read the shared `RAW` schema. Models without a custom schema
build in the personal schema; a future `+schema: marts` builds in
`<personal_schema>_marts`. The macro preserves existing production naming:
target `prod` still uses `PROD`, or the exact custom schema when configured.
The production profile is otherwise unchanged.

There is deliberately no shared fallback for `DBT_DEV_SCHEMA` or `DBT_DEV_ROLE`:
missing variables cause dbt to fail instead of writing to a shared development
schema. `env.yml` is processed by Snowflake, not by a standalone dbt CLI. For local
dbt, configure your own authenticated `profiles.yml` with these same `env_var`
references and export both variables in your shell, for example in PowerShell:

```powershell
$env:DBT_DEV_SCHEMA = 'DBT_ALICE' # Developer two uses DBT_BOB; use your own unique name.
$env:DBT_DEV_ROLE = 'YOUR_DEVELOPMENT_ROLE'
```

The checked-in Snowflake-native profile uses session authentication placeholders
and is not a local connection profile. Do not commit local credentials. CI runs
using target `dev` resolve the schema from the executing service user, rather than
either developer; concurrent CI runs with the same user still share that schema.

References: [Snowflake environment best practices](https://docs.snowflake.com/en/user-guide/data-engineering/dbt-projects-on-snowflake-best-practices)
and [dbt custom schemas](https://docs.getdbt.com/docs/build/custom-schemas).
