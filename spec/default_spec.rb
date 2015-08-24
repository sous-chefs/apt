require 'spec_helper'

describe 'apt::default' do
  let(:chef_run) do
    runner = ChefSpec::Runner.new
    runner.converge('apt::default')
  end

  it 'creates 10recommends file' do
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('# Managed by Chef')
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('APT::Install-Recommends "1";')
    expect(chef_run).to render_file('/etc/apt/apt.conf.d/10recommends').with_content('APT::Install-Suggests "0";')
  end

  # it 'installs update-notifier-common' do
  #   expect(chef_run).to install_package 'update-notifier-common'
  # end

  # it 'apt-get updates' do
  #   expect(chef_run).to execute_command 'apt-get update'
  # end

  # it 'creates preseeding directory' do
  #   expect(chef_run).to create_directory('/var/cache/local')
  #   expect(chef_run).to create_directory('/var/cache/local/preseeding')
  # end
end
