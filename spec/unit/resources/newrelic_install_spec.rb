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

    it 'run bash newrelic install command with infra' do
      expect(subject).to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end

    it 'uses --preserve-env instead of sudo -E' do
      expect(subject).to run_execute('newrelic install').with(command: include('--preserve-env='))
      expect(subject).not_to run_execute('newrelic install').with(command: include('sudo -E'))
    end

    it 'includes core NR env vars in --preserve-env list' do
      expect(subject).to run_execute('newrelic install').with(command: include('NEW_RELIC_API_KEY'))
      expect(subject).to run_execute('newrelic install').with(command: include('NEW_RELIC_ACCOUNT_ID'))
      expect(subject).to run_execute('newrelic install').with(command: include('NEW_RELIC_REGION'))
    end

  end

  context 'when env contains additional vars' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['infrastructure-agent-installer']
    default_attributes['newrelic_install']['env']['HTTPS_PROXY'] = 'http://proxy.example.com:8080'

    it 'includes extra env vars in --preserve-env list' do
      expect(subject).to run_execute('newrelic install').with(command: include('HTTPS_PROXY'))
    end
  end

  context 'when targets only contains infra, logs and php' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = %w(infrastructure-agent-installer logs-integration php-agent-installer)

    it 'run bash newrelic install command with infra' do
      expect(subject).to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end

    it 'run bash newrelic install command with logs' do
      expect(subject).to run_execute('newrelic install').with(command: include('logs-integration'))
    end

    it 'run bash newrelic install command with php' do
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

    it 'run bash newrelic install command without infra' do
      expect(subject).not_to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end

    it 'run bash newrelic install command with php' do
      expect(subject).to run_execute('newrelic install').with(command: include('-n php-agent-installer'))
    end
  end

  context 'when targets only contains infra, logs and dotnet' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = %w(infrastructure-agent-installer logs-integration dotnet-agent-installer)

    it 'run bash newrelic install command with infra' do
      expect(subject).to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end

    it 'run bash newrelic install command with logs' do
      expect(subject).to run_execute('newrelic install').with(command: include('logs-integration'))
    end

    it 'run bash newrelic install command with dotnet' do
      expect(subject).to run_execute('newrelic install').with(command: include('dotnet-agent-installer'))
    end
  end

  context 'when targets only contains dotnet' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['dotnet-agent-installer']

    it 'should execute with target infra and skip core' do
      expect(subject).to run_execute('newrelic install').with(env: have_key('NEW_RELIC_CLI_SKIP_CORE'))
    end

    it 'run bash newrelic install command without infra' do
      expect(subject).not_to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end

    it 'run bash newrelic install command with dotnet' do
      expect(subject).to run_execute('newrelic install').with(command: include('-n dotnet-agent-installer'))
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

    it 'run powershell newrelic install command' do
      expect(subject).to run_powershell_script('newrelic install').with(code: include('infrastructure-agent-installer'))
    end
  end

  context 'when execute on windows and targets only contains infra, logs and dotnet' do
    platform 'windows'
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = %w(infrastructure-agent-installer logs-integration dotnet-agent-installer)

    it 'run powershell newrelic install command' do
      expect(subject).to run_powershell_script('newrelic install').with(code: include('infrastructure-agent-installer'))
    end

    it 'run powershell newrelic install command with logs' do
      expect(subject).to run_powershell_script('newrelic install').with(code: include('logs-integration'))
    end

    it 'run powershell newrelic install command with dotnet' do
      expect(subject).to run_powershell_script('newrelic install').with(code: include('dotnet-agent-installer'))
    end
  end

  context 'when execute on windows and targets only contains dotnet' do
    platform 'windows'
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['dotnet-agent-installer']

    it 'should execute with target infra and skip core' do
      expect(subject).to run_powershell_script('newrelic install').with(env: have_key('NEW_RELIC_CLI_SKIP_CORE'))
    end

    it 'run powershell newrelic install command without infra' do
      expect(subject).not_to run_powershell_script('newrelic install').with(code: include('infrastructure-agent-installer'))
    end

    it 'run powershell newrelic install command with dotnet' do
      expect(subject).to run_powershell_script('newrelic install').with(code: include('-n dotnet-agent-installer'))
    end
  end

  context 'when targets only contains agent control' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['agent-control']

    it 'should execute with target infra and skip core' do
      expect(subject).to run_execute('newrelic install').with(env: have_key('NEW_RELIC_CLI_SKIP_CORE'))
    end

    it 'run bash newrelic install command with agent-control' do
      expect(subject).to run_execute('newrelic install').with(command: include('agent-control'))
    end

    it 'run powershell newrelic install command without agent-control' do
      expect(subject).not_to run_powershell_script('newrelic install').with(code: include('agent-control'))
    end
  end

  context 'when targets contains agent control infra agent and logs' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = %w(agent-control infrastructure-agent-installer logs-integration)

    it 'should execute with target infra and skip core' do
      expect(subject).to run_execute('newrelic install').with(env: have_key('NEW_RELIC_CLI_SKIP_CORE'))
    end

    it 'run bash newrelic install command with agent-control' do
      expect(subject).to run_execute('newrelic install').with(command: include('agent-control'))
    end

    it 'run bash newrelic install command with infra' do
      expect(subject).to run_execute('newrelic install').with(command: include('infrastructure-agent-installer'))
    end

    it 'run bash newrelic install command with logs' do
      expect(subject).to run_execute('newrelic install').with(command: include('logs-integration'))
    end
  end
  context 'when targets only contains agent control logs' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['logs-integration-agent-control']

    it 'should execute with target infra and skip core' do
      expect(subject).to run_execute('newrelic install').with(env: have_key('NEW_RELIC_CLI_SKIP_CORE'))
    end

    it 'run bash newrelic install command with logs-integration-agent-control' do
      expect(subject).to run_execute('newrelic install').with(command: include('logs-integration-agent-control'))
    end

    it 'run powershell newrelic install command without logs-integration-agent-control' do
      expect(subject).not_to run_powershell_script('newrelic install').with(code: include('logs-integration-agent-control'))
    end
  end

  context 'when targets only contains nrdot-collector-mysql' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-mysql']

    it 'run bash newrelic install command with nrdot-collector-mysql' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-mysql'))
    end
  end

  context 'when targets only contains nrdot-collector-mysql-rds' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-mysql-rds']

    it 'run bash newrelic install command with nrdot-collector-mysql-rds' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-mysql-rds'))
    end
  end

  context 'when targets only contains nrdot-collector-postgresql' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-postgresql']

    it 'run bash newrelic install command with nrdot-collector-postgresql' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-postgresql'))
    end
  end

  context 'when targets only contains nrdot-collector-postgresql-rds' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-postgresql-rds']

    it 'run bash newrelic install command with nrdot-collector-postgresql-rds' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-postgresql-rds'))
    end
  end

  context 'when targets only contains nrdot-collector-mssql' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-mssql']

    it 'run bash newrelic install command with nrdot-collector-mssql' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-mssql'))
    end
  end

  context 'when targets only contains nrdot-collector-mssql-winauth' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-mssql-winauth']

    it 'run bash newrelic install command with nrdot-collector-mssql-winauth' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-mssql-winauth'))
    end
  end

  context 'when targets only contains nrdot-collector-mssql-rds' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-mssql-rds']

    it 'run bash newrelic install command with nrdot-collector-mssql-rds' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-mssql-rds'))
    end
  end

  context 'when targets only contains nrdot-collector-mssql-rds-winauth' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-mssql-rds-winauth']

    it 'run bash newrelic install command with nrdot-collector-mssql-rds-winauth' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-mssql-rds-winauth'))
    end
  end

  context 'when targets only contains nrdot-collector-oracle' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-oracle']

    it 'run bash newrelic install command with nrdot-collector-oracle' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-oracle'))
    end
  end

  context 'when targets only contains nrdot-collector-oracle-rds' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-oracle-rds']

    it 'run bash newrelic install command with nrdot-collector-oracle-rds' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-oracle-rds'))
    end
  end

  context 'when targets only contains nrdot-collector-oracle-adb' do
    default_attributes['newrelic_install']['NEW_RELIC_API_KEY'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_ACCOUNT_ID'] = 'xxx'
    default_attributes['newrelic_install']['NEW_RELIC_REGION'] = 'xxx'
    default_attributes['newrelic_install']['targets'] = ['nrdot-collector-oracle-adb']

    it 'run bash newrelic install command with nrdot-collector-oracle-adb' do
      expect(subject).to run_execute('newrelic install').with(command: include('nrdot-collector-oracle-adb'))
    end
  end
end
