require 'spec_helper'

describe 'zram' do
  context 'with defaults for all parameters' do
    it { is_expected.to compile }
    it { is_expected.to contain_class('zram') }
    it { is_expected.to contain_file('/lib/udev/zram').with(
      'ensure' => 'file',
      'owner'  => 'root',
      'group'  => 'root',
      'mode'   => '0755',
    )}
    it { is_expected.to contain_file('/etc/udev/rules.d/01-zram.rules').with(
      'ensure' => 'file',
    ).with_content(/^KERNEL=="zram\*", ACTION=="add", RUN=="\/lib\/udev\/zram \d+"$/)}
  end
end
