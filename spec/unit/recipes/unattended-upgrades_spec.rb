require 'spec_helper'

describe 'apt::unattended-upgrades' do
  platform 'ubuntu'

  it do
    expect(chef_run).to install_package('unattended-upgrades')
  end

  it 'creates 20auto-upgrades file' do
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/20auto-upgrades').with_content('APT::Periodic::Update-Package-Lists "1";')
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/20auto-upgrades').with_content('APT::Periodic::Unattended-Upgrade "0";')
  end

  it 'creates 50unattended-upgrades file' do
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/50unattended-upgrades').with_content(
      '// Automatically upgrade packages from these (origin:archive) pairs'
    )
  end
end
