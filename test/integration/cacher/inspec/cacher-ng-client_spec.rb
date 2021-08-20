describe service('apt-cacher-ng') do
  it { should be_enabled }
  it { should be_running }
end

describe directory('/var/cache/apt-cacher-ng') do
  it { should exist }
  its('owner') { should eq 'apt-cacher-ng' }
end

describe file('/etc/apt/apt.conf.d/01proxy') do
  its('content') { should match %r{Acquire::http::Proxy "http://.*:9876";} }
end

describe package('colordiff') do
  it { should be_installed }
end
