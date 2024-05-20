# frozen_string_literal: true

provides :newrelic_install
unified_mode true

property :new_relic_api_key,      String
property :new_relic_account_id,   String
property :new_relic_region,       String
property :targets,                Array, default: []
property :env,                    Hash
property :verbosity,              String
property :timeout_seconds,        Integer, default: 600
property :tags,                   Hash, default: {}

action :install do
  check_license
  check_targets
  options = '-y'
  options += get_verbosity(new_resource.verbosity) unless new_resource.verbosity.nil? || new_resource.verbosity.empty?
  options += stringify_targets(new_resource.targets)
  options += get_tags(new_resource.tags)

  if platform?('windows')
    powershell_script 'newrelic install' do
      code "[Net.ServicePointManager]::SecurityProtocol = 'tls12, tls'; (New-Object System.Net.WebClient).DownloadFile(\"https://download.newrelic.com/install/newrelic-cli/scripts/install.ps1\", \"$env:TEMP\\install.ps1\"); & PowerShell.exe -ExecutionPolicy Bypass -File $env:TEMP\\install.ps1; & 'C:\\Program Files\\New Relic\\New Relic CLI\\newrelic.exe' install #{options}"
      live_stream true
      environment new_resource.env
      timeout new_resource.timeout_seconds
    end
  else
    execute 'newrelic install' do
      command "curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo -E /usr/local/bin/newrelic install #{options}"
      live_stream true
      environment new_resource.env
      timeout new_resource.timeout_seconds
    end
  end
end

action_class do
  def check_license
    if new_resource.new_relic_api_key.nil? || new_resource.new_relic_api_key.empty?
      if ENV['NEW_RELIC_API_KEY'].nil? || ENV['NEW_RELIC_API_KEY'].empty?
        raise ArgumentError, 'Please specify your newrelic api key'
      end
    else
      ENV['NEW_RELIC_API_KEY'] = new_resource.new_relic_api_key
    end

    if new_resource.new_relic_account_id.nil? || new_resource.new_relic_account_id.empty?
      if ENV['NEW_RELIC_ACCOUNT_ID'].nil? || ENV['NEW_RELIC_ACCOUNT_ID'].empty?
        raise ArgumentError, 'Please specify your newrelic account key'
      end
    else
      ENV['NEW_RELIC_ACCOUNT_ID'] = new_resource.new_relic_account_id
    end

    if new_resource.new_relic_region.nil? || new_resource.new_relic_region.empty?
      if ENV['NEW_RELIC_REGION'].nil? || ENV['NEW_RELIC_REGION'].empty?
        raise ArgumentError, 'Please specify your newrelic region'
      end
    else
      ENV['NEW_RELIC_REGION'] = new_resource.new_relic_region
    end
  end

  def check_targets
    allowed_targets = Set.new(%w(
    infrastructure-agent-installer
    logs-integration
    php-agent-installer
    dotnet-agent-installer
    super-agent
    logs-integration-super-agent
    ))
    allowed_targets_string = allowed_targets.join(', ')
    incoming_targets = new_resource.targets.to_set

    if incoming_targets.nil? || incoming_targets.empty?
      raise ArgumentError, 'Targets must contain at least one installation target'
    end

    raise ArgumentError, "Targets must only contains valid value(#{allowed_targets_string})" unless incoming_targets.subset?(allowed_targets)

    if incoming_targets.include?('logs-integration')
      raise ArgumentError, 'Targets must include infrastructure-agent-installer if log is included' unless incoming_targets.include?('infrastructure-agent-installer')
    end
  end

  def stringify_targets(targets)
    _ = " -n #{targets.join(',')}" unless targets.nil? || targets.empty?
  end

  def get_verbosity(verbosity)
    verbosity_modes = %w(debug trace)
    _ = " --#{verbosity}" if verbosity_modes.include? verbosity
  end

  def get_tags(tags)
    deploy_tag = 'nr_deployed_by:chef-install'
    tags_array = []
    tags.each do |key, value|
      tags_array.append("#{key}:#{value}")
    end
    tags_array.append(deploy_tag)
    _ = " --tag #{tags_array.join(',')}"
  end
end
