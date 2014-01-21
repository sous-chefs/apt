require 'spec_helper'

describe 'rackspace_apt::cacher-ng' do

  context 'server' do
    let(:chef_run) do
      runner = ChefSpec::Runner.new
      runner.node.set['rackspace_apt']['config']['cacher_server']['Port']['value'] = '9876'
      runner.converge('rackspace_apt::cacher-ng')
    end

    it 'installs apt-cacher-ng' do
      expect(chef_run).to install_package('apt-cacher-ng')
    end

    it 'creates acng.conf file' do
      expect(chef_run).to create_template('/etc/apt-cacher-ng/acng.conf')
    end

    it 'enables and starts apt-cacher-ng' do
      expect(chef_run).to enable_service('apt-cacher-ng')
      expect(chef_run).to start_service('apt-cacher-ng')
    end

  end

end
