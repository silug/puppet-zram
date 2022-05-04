require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'beaker/module_install_helper'

if ENV.key?('BEAKER_RHSM_USER')
  rhel = []

  hosts.each do |host|
    rhel << host if fact_on(host, 'os.name').strip == 'RedHat'
  end

  unless rhel.empty?
    register_args = ['--auto-attach', "--username='#{ENV['BEAKER_RHSM_USER']}'"]
    register_args << "--password='#{ENV['BEAKER_RHSM_PASSWORD']}'" if ENV.key?('BEAKER_RHSM_PASSWORD')

    on(rhel, "subscription-manager register #{register_args.join(' ')}")

    Rspec.configure do |c|
      c.after(:all) do
        on(rhel, 'subscription-manager unregister')
      end
    end
  end
end

# Hack to get around Puppet not being available for all versions of Fedora
ok_hosts = hosts.reject do |host|
  begin
    on(host, 'type -p puppet')
  rescue
    false
  end
end

run_puppet_install_helper_on(ok_hosts) unless ok_hosts.empty?

install_module_on(hosts)
install_module_dependencies_on(hosts)
