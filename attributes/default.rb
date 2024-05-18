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
# super-agent
# logs-integration-super-agent
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
