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
      it {
        is_expected.to contain_file('/lib/udev/zram').with(
          'ensure' => 'file',
          'owner'  => 'root',
          'group'  => 'root',
          'mode'   => '0755',
        )
      }
      it {
        is_expected.to contain_file('/etc/udev/rules.d/01-zram.rules').with(
          'ensure' => 'file',
        ).with_content(%r{^KERNEL=="zram\*", ACTION=="add", RUN=="/lib/udev/zram 536870912"$})
      }
    end
  end
end
