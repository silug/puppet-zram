require 'spec_helper'

describe 'zram' do
  on_supported_os.each do |os, facts|
    context "on #{os} with defaults for all parameters" do
      let(:facts) do
        facts.merge(
          'processorcount' => 4,
          'memorysize_mb'  => 4096,
          'augeasversion'  => '1.4.0',
        )
      end

      it { is_expected.to compile }

      it { is_expected.to contain_class('zram') }

      it { is_expected.to contain_class('zram::config') }

      it do
        is_expected.to contain_file('/lib/udev/zram').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        )
      end

      it do
        is_expected.to contain_file('/etc/udev/rules.d/01-zram.rules').with(
          'ensure' => 'file',
        ).with_content(%r{^KERNEL=="zram\*", ACTION=="add", RUN\+="/lib/udev/zram 536870912"$})
      end

      it do
        is_expected.to contain_kmod__option('zram').with(
          'option' => 'num_devices',
          'value'  => 4,
        )
      end

      it { is_expected.to contain_class('zram::load') }

      if facts[:os]['name'] == 'Ubuntu'
        it { is_expected.to contain_package("linux-modules-extra-#{facts[:kernelrelease]}") }
      end

      it { is_expected.to contain_kmod__load('zram') }
    end
  end
end
