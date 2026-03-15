# frozen_string_literal: true

control 'apt-unattended-upgrades-01' do
  impact 1.0
  title 'Unattended upgrades configuration exists'

  describe file('/etc/apt/apt.conf.d/50unattended-upgrades') do
    it { should exist }
    its('content') { should match(/"--force-confold";/) }
  end
end
