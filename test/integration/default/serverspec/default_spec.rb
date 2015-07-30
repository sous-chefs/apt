require_relative './spec_helper'

describe 'apt::default' do
  describe file('/var/cache/local/preseeding') do
    it 'is a directory' do
      expect(subject).to be_a_directory
    end
  end
end
