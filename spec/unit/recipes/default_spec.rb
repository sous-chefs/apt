require 'spec_helper'

describe 'apt::default' do
  platform 'ubuntu'

  before do
    allow(::File).to receive(:executable?).and_return(true)
  end

  it 'creates 10recommends file' do
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('# Managed by Chef')
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('APT::Install-Recommends "1";')
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('APT::Install-Suggests "0";')
  end

  it do
    expect(chef_run).to install_package(%w(apt-transport-https gnupg dirmngr))
  end

  it do
    expect(chef_run).to create_directory('/var/cache/local')
    expect(chef_run).to create_directory('/var/cache/local/preseeding')
  end
end
