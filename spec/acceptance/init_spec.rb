require 'spec_helper_acceptance'

describe 'zram' do
  context 'default parameters' do
    it 'should apply with no errors' do
      # Run twice to test idempotency
      apply_manifest('class { zram: }', :catch_failures => true)
      apply_manifest('class { zram: }', :catch_changes => true)
    end
  end
end
