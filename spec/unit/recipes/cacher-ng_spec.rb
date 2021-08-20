require 'spec_helper'

describe 'apt::cacher-ng' do
  platform 'ubuntu'

  context 'server' do
    override_attributes['apt']['cacher_port'] = '9876'

    it { expect(chef_run).to install_package('apt-cacher-ng') }

    it { expect(chef_run).to create_template('/etc/apt-cacher-ng/acng.conf') }

    it { expect(chef_run).to enable_service('apt-cacher-ng') }
  end
end
