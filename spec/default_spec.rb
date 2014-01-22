require 'spec_helper'

describe 'rackspace_apt::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['rackspace_apt']['apt_installed'] = true
    end.converge(described_recipe)
  end

  it 'installs update-notifier-common' do
    expect(chef_run).to install_package('update-notifier-common')
  end

  it 'apt-get updates' do
    expect(chef_run).to run_execute('apt-get-update')
  end

  it 'creates preseeding directory' do
    expect(chef_run).to create_directory('/var/cache/local')
    expect(chef_run).to create_directory('/var/cache/local/preseeding')
  end

end
