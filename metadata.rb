# frozen_string_literal: true

name 'newrelic-install'
maintainer 'newrelic'
maintainer_email 'hzhao@newrelic.com'
license 'All Rights Reserved'
description 'Installs/Configures Newrelic agents using guided install through chef'
source_url        'https://github.com/NRhzhao/chef-install'
issues_url        'https://github.com/NRhzhao/chef-install/issues'
version '0.1.1'
chef_version '>= 15.0'

# Platform support
supports 'amazon', '>= 2013.0'
supports 'debian', '>= 7.0'
supports 'ubuntu', '>= 16.04'
supports 'redhat', '>= 5.0'
supports 'oracle', '>= 6.0'
supports 'centos', '>= 7.0'
supports 'suse'
supports 'windows'
