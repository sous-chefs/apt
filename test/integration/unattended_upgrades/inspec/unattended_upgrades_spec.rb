describe package('unattended-upgrades') do
  it { should be_installed }
end

describe file('/etc/apt/apt.conf.d/20auto-upgrades') do
  its('content') { should match /APT::Periodic::Update-Package-Lists "1";/ }
  its('content') { should match /APT::Periodic::Unattended-Upgrade "1";/ }
end

describe file('/etc/apt/apt.conf.d/50unattended-upgrades') do
  its('content') { should match /Unattended-Upgrade::Allowed-Origins \{.+"(Debian|Ubuntu) .+";.+\};/m }
end
