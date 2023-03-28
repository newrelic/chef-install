require 'spec_helper'

describe 'newrelic-install::default' do
  step_into :newrelic_install
  platform 'ubuntu'

  context 'when api key is undefined' do
    recipe do
      newrelic_install 'test' do
      end
    end

    it 'raises api key missing error' do
      expect { subject }.to raise_error(ArgumentError, /.*api key.*/)
    end
  end

  context 'when account key is undefined' do
    recipe do
      newrelic_install 'test' do
        new_relic_api_key 'key'
      end
    end

    it 'raises account key missing error' do
      expect { subject }.to raise_error(ArgumentError, /.*account key.*/)
    end
  end

  context 'when region is undefined' do
    recipe do
      newrelic_install 'test' do
        new_relic_api_key 'key'
        new_relic_account_id 'id'
      end
    end

    it 'raises region missing error' do
      expect { subject }.to raise_error(ArgumentError, /.*region.*/)
    end
  end

  context 'when targets is undefined' do
    recipe do
      newrelic_install 'test' do
        new_relic_api_key 'key'
        new_relic_account_id 'id'
        new_relic_region 'region'
      end
    end

    it 'raise targets missing error when targets undefined' do
      expect { subject }.to raise_error(ArgumentError, /.*Targets must contain at least one installation target.*/)
    end
  end

  context 'when targets contain invalid value' do
    recipe do
      newrelic_install 'test' do
        new_relic_api_key 'key'
        new_relic_account_id 'id'
        new_relic_region 'region'
        targets ['target']
      end
    end

    it 'raise targets error when have invalid target' do
      expect { subject }.to raise_error(ArgumentError, /.*Targets must only contains valid value.*/)
    end
  end

  context 'when targets only contains log' do
    recipe do
      newrelic_install 'test' do
        new_relic_api_key 'key'
        new_relic_account_id 'id'
        new_relic_region 'region'
        targets ['logs-integration']
      end
    end

    it 'raise infra is required error' do
      expect { subject }.to raise_error(ArgumentError, /.*Targets must include infrastructure-agent-installer if log is included.*/)
    end
  end

  context 'when targets only contains infra' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['infrastructure-agent-installer']

    it 'should execute with target infra and skip core' do
      expect(subject).to run_execute('newrelic install').with(env: have_key('NEW_RELIC_CLI_SKIP_CORE'))
    end

    it 'run bash newrlic install command with infra' do
      expect(subject).to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end
  end

  context 'when targets only contains infra, logs and php' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = %w(infrastructure-agent-installer logs-integration php-agent-installer)

    it 'run bash newrlic install command with infra' do
      expect(subject).to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end

    it 'run bash newrlic install command with logs' do
      expect(subject).to run_execute('newrelic install').with(command: include('logs-integration'))
    end

    it 'run bash newrlic install command with php' do
      expect(subject).to run_execute('newrelic install').with(command: include('php-agent-installer'))
    end
  end

  context 'when targets only contains php' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['php-agent-installer']

    it 'should execute with target infra and skip core' do
      expect(subject).to run_execute('newrelic install').with(env: have_key('NEW_RELIC_CLI_SKIP_CORE'))
    end

    it 'run bash newrlic install command without infra' do
      expect(subject).not_to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end

    it 'run bash newrlic install command with php' do
      expect(subject).to run_execute('newrelic install').with(command: include('-n php-agent-installer'))
    end
  end

  context 'when execute on windows' do
    platform 'windows'
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['infrastructure-agent-installer']

    it 'should execute with target infra and skip core' do
      expect(subject).to run_powershell_script('newrelic install').with(env: have_key('NEW_RELIC_CLI_SKIP_CORE'))
    end

    it 'run powershell newrlic install command' do
      expect(subject).to run_powershell_script('newrelic install').with(code: include('infrastructure-agent-installer'))
    end
  end
end
