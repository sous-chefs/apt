require_relative './spec_helper'

describe 'apt::default' do
  describe file('/tmp/kitchen/cache/apt_compile_time_update_first_run') do
    it 'exists' do
      expect(subject).to exist
    end
  end
end
