require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

run_puppet_install_helper
install_module_on(hosts)
#install_module_dependencies_on(hosts)
install_module_from_forge_on(hosts, 'puppetlabs-stdlib', '>= 4.13.0 < 5.0.0')
install_module_from_forge_on(hosts, 'camptocamp-kmod', '>= 2.1.0 < 3.0.0')
