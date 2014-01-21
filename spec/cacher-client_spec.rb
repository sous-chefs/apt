require 'spec_helper'

describe 'rackspace_apt::cacher-client' do

  before do
    stub_command('grep Acquire::http::Proxy /etc/apt/apt.conf').and_return(true)
  end

  context 'no server' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new
      runner.converge('rackspace_apt::cacher-client')
    end

    it 'does not create 01proxy file' do
      expect(chef_run).not_to create_file('/etc/apt/apt.conf.d/01proxy')
    end
  end

  context 'server provided' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new
      runner.node.set['rackspace_apt']['config']['cacher_client']['cacher_ipaddress'] = '22.33.44.55'
      runner.node.set['rackspace_apt']['config']['cacher_server']['Port']['value'] = '9876'
      runner.converge('rackspace_apt::cacher-client')
    end

    it 'creates 01proxy file' do
      expect(chef_run).to render_file('/etc/apt/apt.conf.d/01proxy').with_content('Acquire::http::Proxy "http://22.33.44.55:9876";')
    end

  end

end
