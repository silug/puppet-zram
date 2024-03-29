require 'spec_helper_acceptance'

describe 'zram' do
  context 'default parameters' do
    it 'is expected to apply with no errors' do
      # Run twice to test idempotency
      apply_manifest('class { zram: }', 'catch_failures' => true)
      apply_manifest('class { zram: }', 'catch_changes' => true)
    end

    it 'reboots to ensure settings take effect' do
      hosts.each { |host| host.reboot }
    end

    describe kernel_module('zram') do
      it { is_expected.to be_loaded }
    end

    describe file('/proc/swaps') do
      its(:content) do
        is_expected.to match(%r{^/dev/zram[0-9]+[ \t][[:alnum:] \t]*[ \t]32767$})
        is_expected.not_to match(%r{^/dev/zram[0-9]+[ \t][[:alnum:] \t]*(?<!32767)$})
      end
    end
  end
end
