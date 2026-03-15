# frozen_string_literal: true

control 'apt-cacher-01' do
  impact 1.0
  title 'APT cacher server and client configuration exist'

  describe service('apt-cacher-ng') do
    it { should be_enabled }
    it { should be_running }
  end

  describe file('/tmp/apt-cacher') do
    it { should be_directory }
    it { should be_owned_by 'apt-cacher-ng' }
  end

  describe file('/etc/apt/apt.conf.d/01proxy') do
    it { should exist }
    its('content') { should match(%r{Acquire::http::Proxy "http://localhost:9876";}) }
  end
end
