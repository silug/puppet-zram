require 'spec_helper'

describe 'zram' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts[:processors]['count'] = 4
        os_facts[:memory]['system']['total_bytes'] = 4_294_967_296
        os_facts[:augeasversion] = '1.14.1'

        os_facts
      end

      context 'with defaults for all parameters' do
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

        it { is_expected.to contain_class('zram::install') }

        if os_facts[:os]['name'] == 'Ubuntu'
          it { is_expected.to contain_package("linux-modules-extra-#{facts[:kernelrelease]}").with_ensure('installed') }
        end

        if os_facts[:os]['name'] == 'Fedora'
          it { is_expected.to contain_package('zram-generator-defaults').with_ensure('absent') }
          it { is_expected.to contain_package('zram-generator').with_ensure('absent') }
        end

        it { is_expected.to contain_class('zram::load') }

        it { is_expected.to contain_kmod__load('zram') }
      end

      context 'with ensure => absent' do
        let(:params) { { 'ensure' => 'absent' } }

        it { is_expected.to compile }

        it { is_expected.to contain_class('zram') }

        it { is_expected.to contain_class('zram::config') }

        it do
          is_expected.to contain_file('/lib/udev/zram')
            .with_ensure('absent')
        end

        it do
          is_expected.to contain_file('/etc/udev/rules.d/01-zram.rules')
            .with_ensure('absent')
        end

        it do
          is_expected.to contain_kmod__option('zram')
            .with_ensure('absent')
        end

        it { is_expected.to contain_class('zram::install') }

        if os_facts[:os]['name'] == 'Ubuntu'
          it { is_expected.not_to contain_package("linux-modules-extra-#{facts[:kernelrelease]}") }
        end

        if os_facts[:os]['name'] == 'Fedora'
          it { is_expected.not_to contain_package('zram-generator-defaults') }
          it { is_expected.not_to contain_package('zram-generator') }
        end

        it { is_expected.to contain_class('zram::load') }

        it { is_expected.not_to contain_exec('Disable zram swap') }
        it { is_expected.to contain_kmod__load('zram').with_ensure('absent') }
      end

      context 'with ensure => absent and swapoff => true' do
        let(:params) do
          {
            'ensure'  => 'absent',
            'swapoff' => true,
          }
        end

        it { is_expected.to compile }

        it { is_expected.to contain_class('zram') }

        it { is_expected.to contain_class('zram::config') }

        it do
          is_expected.to contain_file('/lib/udev/zram')
            .with_ensure('absent')
        end

        it do
          is_expected.to contain_file('/etc/udev/rules.d/01-zram.rules')
            .with_ensure('absent')
        end

        it do
          is_expected.to contain_kmod__option('zram')
            .with_ensure('absent')
        end

        it { is_expected.to contain_class('zram::install') }

        if os_facts[:os]['name'] == 'Ubuntu'
          it { is_expected.not_to contain_package("linux-modules-extra-#{facts[:kernelrelease]}") }
        end

        if os_facts[:os]['name'] == 'Fedora'
          it { is_expected.not_to contain_package('zram-generator-defaults') }
          it { is_expected.not_to contain_package('zram-generator') }
        end

        it { is_expected.to contain_class('zram::load') }

        it { is_expected.to contain_exec('Disable zram swap').that_comes_before('Kmod::Load[zram]') }
        it { is_expected.to contain_kmod__load('zram').with_ensure('absent') }
      end
    end
  end
end
