# frozen_string_literal: true

newrelic_install 'install' do
  action                   :install
  new_relic_api_key        node['newrelic_install']['NEW_RELIC_API_KEY']
  new_relic_account_id     node['newrelic_install']['NEW_RELIC_ACCOUNT_ID']
  new_relic_region         node['newrelic_install']['NEW_RELIC_REGION']
  env                      node['newrelic_install']['env']
  targets                  node['newrelic_install']['targets']
end
