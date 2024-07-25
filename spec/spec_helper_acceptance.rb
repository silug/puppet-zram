require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

# Hack to get around Puppet not being available for all versions of Fedora
ok_hosts = hosts.reject do |host|
  on(host, 'type -p puppet')
rescue
  false
end

run_puppet_install_helper_on(ok_hosts) unless ok_hosts.empty?

install_module_on(hosts)
install_module_dependencies_on(hosts)
