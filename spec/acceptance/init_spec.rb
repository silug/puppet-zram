require 'spec_helper_acceptance'

shared_examples 'zram enabled' do
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

shared_examples 'zram disabled' do
  describe kernel_module('zram') do
    it { is_expected.not_to be_loaded }
  end

  describe file('/proc/swaps') do
    its(:content) do
      is_expected.not_to match(%r{^/dev/zram[0-9]+\b})
    end
  end
end

describe 'zram' do
  context 'with default parameters' do
    include_examples 'zram enabled'
  end

  context 'with ensure => absent' do
    let(:manifest) do
      <<~END_MANIFEST
        class { zram:
          ensure  => absent,
        }
      END_MANIFEST
    end

    it_behaves_like 'zram enabled'

    context 'with zram enabled' do
      it 'is expected to apply with errors' do
        # Ignoring result
        apply_manifest(manifest, 'catch_failures' => false)
      end

      it 'reboots to ensure settings are permanent' do
        hosts.each { |host| host.reboot }
      end

      it_behaves_like 'zram disabled'
    end
  end

  context 'with ensure => absent and swapoff => true' do
    let(:manifest) do
      <<~END_MANIFEST
        class { zram:
          ensure  => absent,
          swapoff => true,
        }
      END_MANIFEST
    end

    it_behaves_like 'zram enabled'

    context 'with zram enabled' do
      it 'is expected to apply with no errors' do
        # Run twice to test idempotency
        apply_manifest(manifest, 'catch_failures' => true)
        apply_manifest(manifest, 'catch_changes' => true)
      end

      include_examples 'zram disabled'

      context 'with module unloaded' do
        it 'reboots to ensure settings are permanent' do
          hosts.each { |host| host.reboot }
        end

        include_examples 'zram disabled'
      end
    end
  end
end
