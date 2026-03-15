# frozen_string_literal: true

control 'apt-compile-time-01' do
  impact 1.0
  title 'APT update stamp exists'

  describe file('/var/lib/apt/periodic/update-success-stamp') do
    it { should exist }
  end
end
