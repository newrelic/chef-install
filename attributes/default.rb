# frozen_string_literal: true

# REQUIRED #
############
############

default['newrelic_install']['env']['NEW_RELIC_API_KEY'] = ''
default['newrelic_install']['env']['NEW_RELIC_ACCOUNT_ID'] = ''

############
# OPTIONAL #
############

default['newrelic_install']['env']['NEW_RELIC_REGION'] = 'US'
default['newrelic_install']['env']['HTTP_PROXYS'] = nil

default['newrelic_install']['verbosity'] = ''

####################
# TARGETED INSTALL #
####################

default['newrelic_install']['targets'] = []

########
# TAGS #
########

default['newrelic_install']['tags'] = {}

################
# CLI BEHAVIOR #
################

default['newrelic_install']['timeout_seconds'] = 600
