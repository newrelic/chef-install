# frozen_string_literal: true

############
# REQUIRED #
############

default['newrelic_install']['NEW_RELIC_API_KEY'] = ''
default['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = ''

############
# OPTIONAL #
############

default['newrelic_install']['NEW_RELIC_REGION'] = 'US'
default['newrelic_install']['env']['HTTPS_PROXY'] = nil
default['newrelic_install']['env']['NEW_RELIC_CLI_SKIP_CORE'] = '1'
default['newrelic_install']['verbosity'] = ''

####################
# TARGETED INSTALL #
####################

# infrastructure-agent-installer
# logs-integration
# php-agent-installer
# dotnet-agent-installer
# agent-control
# logs-integration-agent-control
# nrdot-collector-mysql
# nrdot-collector-mysql-rds
# nrdot-collector-postgresql
# nrdot-collector-postgresql-rds
# nrdot-collector-mssql
# nrdot-collector-mssql-winauth
# nrdot-collector-mssql-rds
# nrdot-collector-mssql-rds-winauth
# nrdot-collector-oracle
# nrdot-collector-oracle-rds
# nrdot-collector-oracle-adb
default['newrelic_install']['targets'] = []

########
# TAGS #
########

default['newrelic_install']['tags'] = {}

################
# CLI BEHAVIOR #
################

default['newrelic_install']['timeout_seconds'] = '600'

#############
# PHP, DOTNET #
#############

# optional name for your application
default['newrelic_install']['env']['NEW_RELIC_APPLICATION_NAME'] = ''

############################
# NRDOT MYSQL, POSTGRESQL #
############################

# These targets now configure one collector against one or more instances via
# an instances file (YAML: host/port/login_name per instance) plus a secrets
# file (KEY=VALUE per line, admin credentials indexed by instance number).
# Env vars vary by variant (local vs RDS) and include file paths rather than
# inline credentials, so no defaults are declared here. Set only the vars
# needed for your chosen target via env attribute overrides.
#
# nrdot-collector-mysql:
#   NR_CLI_MYSQL_CONFIG_PRESET, NR_CLI_MYSQL_INSTANCES_FILE, NR_CLI_MYSQL_SECRETS_FILE
#   secrets file per instance <i>: NR_CLI_MYSQL_ADMIN_USER_<i>, NR_CLI_MYSQL_ADMIN_PASSWORD_<i> (root creds)
#
# nrdot-collector-mysql-rds:
#   NR_CLI_MYSQL_CONFIG_PRESET, NR_CLI_MYSQL_INSTANCES_FILE, NR_CLI_MYSQL_SECRETS_FILE
#   (optional: NR_CLI_MYSQL_TLS_CA_FILE)
#   secrets file per instance <i>: NR_CLI_MYSQL_ADMIN_USER_<i>, NR_CLI_MYSQL_ADMIN_PASSWORD_<i> (RDS master creds)
#
# nrdot-collector-postgresql:
#   NR_CLI_POSTGRES_CONFIG_PRESET, NR_CLI_POSTGRES_INSTANCES_FILE, NR_CLI_POSTGRES_SECRETS_FILE
#   (optional: NR_CLI_POSTGRES_ENABLE_EXPLAIN_HELPER)
#   instances file: databases (required per instance, e.g. [app1, app2])
#   secrets file per instance <i>: NR_CLI_POSTGRES_SUPERUSER_USER_<i>, NR_CLI_POSTGRES_SUPERUSER_PASSWORD_<i>
#
# nrdot-collector-postgresql-rds:
#   NR_CLI_POSTGRES_CONFIG_PRESET, NR_CLI_POSTGRES_INSTANCES_FILE, NR_CLI_POSTGRES_SECRETS_FILE
#   (optional: NR_CLI_POSTGRES_ENABLE_EXPLAIN_HELPER)
#   instances file: databases (required per instance, e.g. [app1, app2])
#   secrets file per instance <i>: NR_CLI_POSTGRES_ADMIN_USER_<i>, NR_CLI_POSTGRES_ADMIN_PASSWORD_<i> (RDS master creds)
#
# A bad instance (wrong password, unsupported version, failed user setup) is
# skipped with a logged reason rather than aborting the whole install.
# See https://github.com/newrelic/open-install-library/pull/1434
#######################
# NRDOT MSSQL, ORACLE #
#######################

# nrdot-collector-mssql, nrdot-collector-mssql-rds, nrdot-collector-mssql-winauth
# and nrdot-collector-mssql-rds-winauth all configure one collector against one
# or more instances via an instances file (host/port per instance). Env vars
# vary by variant, so no defaults are declared here. Set only the vars needed
# for your chosen target via env attribute overrides.
#
# nrdot-collector-mssql:
#   NR_CLI_MSSQL_CONFIG_PRESET, NR_CLI_MSSQL_INSTANCES_FILE, NR_CLI_MSSQL_SECRETS_FILE
#   secrets file per instance <i>: NR_CLI_MSSQL_ADMIN_USER_<i>, NR_CLI_MSSQL_ADMIN_PASSWORD_<i> (sa creds)
#
# nrdot-collector-mssql-rds:
#   NR_CLI_MSSQL_CONFIG_PRESET, NR_CLI_MSSQL_INSTANCES_FILE, NR_CLI_MSSQL_SECRETS_FILE
#   secrets file per instance <i>: NR_CLI_MSSQL_ADMIN_USER_<i>, NR_CLI_MSSQL_ADMIN_PASSWORD_<i> (RDS master creds)
#
# nrdot-collector-mssql-winauth:
#   NR_CLI_MSSQL_CONFIG_PRESET, NR_CLI_MSSQL_AUTH_MODE, NR_CLI_MSSQL_WINAUTH_LOCATION,
#   NR_CLI_MSSQL_INSTANCES_FILE (host/port per instance, no secrets file - one Windows
#   identity monitors every instance in the file)
#   NR_CLI_MSSQL_WIN_ACCOUNT, NR_CLI_MSSQL_WIN_PASSWORD (Windows Domain Auth, different
#   host only), NR_CLI_MSSQL_GMSA_ACCOUNT (gMSA only)
#
# nrdot-collector-mssql-rds-winauth:
#   NR_CLI_MSSQL_CONFIG_PRESET, NR_CLI_MSSQL_AUTH_MODE,
#   NR_CLI_MSSQL_INSTANCES_FILE (host/port per instance, no secrets file - one Windows
#   identity monitors every instance in the file)
#   NR_CLI_MSSQL_WIN_ACCOUNT, NR_CLI_MSSQL_WIN_PASSWORD (Windows Domain Auth only),
#   NR_CLI_MSSQL_GMSA_ACCOUNT (gMSA only)
#
# nrdot-collector-oracle:
#   NR_CLI_ORACLE_CONFIG_PRESET, NR_CLI_ORACLE_INSTANCES_FILE
#   (optional: NR_CLI_ORACLE_SECRETS_FILE - not required, no SYS access needed)
#   secrets file per instance <i> (optional): NR_CLI_ORACLE_LOGIN_PASSWORD_<i> (fixed password override)
#
# nrdot-collector-oracle-rds:
#   NR_CLI_ORACLE_CONFIG_PRESET, NR_CLI_ORACLE_INSTANCES_FILE, NR_CLI_ORACLE_SECRETS_FILE
#   secrets file per instance <i>: NR_CLI_ORACLE_ADMIN_USER_<i>, NR_CLI_ORACLE_ADMIN_PASSWORD_<i> (RDS master creds)
#   (optional per instance: NR_CLI_ORACLE_LOGIN_PASSWORD_<i>)
#
# nrdot-collector-oracle-adb:
#   NR_CLI_ORACLE_INSTANCES_FILE (no NR_CLI_ORACLE_CONFIG_PRESET - ADB has no host to monitor)
#   instances file: each instance also needs wallet_dir (path to that instance's unzipped
#   Oracle Wallet - download per instance from the ADB console, do not share between instances)
#   NR_CLI_ORACLE_SECRETS_FILE (required)
#   secrets file per instance <i>: NR_CLI_ORACLE_ADMIN_USER_<i>, NR_CLI_ORACLE_ADMIN_PASSWORD_<i> (ADB admin creds)
#   (optional per instance: NR_CLI_ORACLE_LOGIN_PASSWORD_<i>)
#   Requires sqlplus (Oracle Instant Client) installed and on PATH on the collector host.
#
# A bad instance (wrong password, unsupported version, failed user setup) is
# skipped with a logged reason rather than aborting the whole install.
# See https://github.com/newrelic/open-install-library/pull/1434 and
# https://github.com/newrelic/open-install-library/pull/1440 (winauth variants)
# for the authoritative recipe definitions (open at time of writing).
