# frozen_string_literal: true

control 'apt-default-01' do
  impact 1.0
  title 'APT base configuration exists'

  describe file('/var/cache/local/preseeding') do
    it { should be_directory }
  end

  describe file('/etc/apt/apt.conf.d/10dpkg-options') do
    it { should exist }
  end

  describe file('/etc/apt/apt.conf.d/10recommends') do
    it { should exist }
  end
end
