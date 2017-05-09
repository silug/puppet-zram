require 'spec_helper_acceptance'

describe 'zram' do
  context 'default parameters' do
    it 'should apply with no errors' do
      # Run twice to test idempotency
      apply_manifest('class { zram: }', :catch_failures => true)
      apply_manifest('class { zram: }', :catch_changes => true)
    end
    describe kernel_module('zram') do
      it { should be_loaded }
    end
    describe file('/proc/swaps') do
      its(:content) { should match(/^\/dev\/zram[0-9]/) }
    end
  end
end
