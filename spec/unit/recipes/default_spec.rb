require 'spec_helper'

describe 'apt::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04') do |node|
      node.automatic[:lsb][:codename] = 'trusty'
    end.converge('apt::default')
  end

  before do
    allow(::File).to receive(:executable?).and_return(true)
  end

  it 'creates 10recommends file' do
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('# Managed by Chef')
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('APT::Install-Recommends "1";')
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('APT::Install-Suggests "0";')
  end

  it 'installs apt-transport-https' do
    expect(chef_run).to install_package('apt-transport-https')
  end

  it 'creates preseeding directory' do
    expect(chef_run).to create_directory('/var/cache/local')
    expect(chef_run).to create_directory('/var/cache/local/preseeding')
  end
end
