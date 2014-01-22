require 'spec_helper'

describe 'rackspace_apt::repos' do

  context 'rackspace mirrors enabled - ubuntu - rackspace not in sources.list' do
    before do
      stub_command("egrep 'mirror.rackspace.com/ubuntu/? precise' /etc/apt/sources.list").and_return(false)
      stub_command("egrep 'mirror.rackspace.com/ubuntu/? precise-updates' /etc/apt/sources.list").and_return(false)
      stub_command("egrep 'mirror.rackspace.com/ubuntu/? precise-backports' /etc/apt/sources.list").and_return(false)
      stub_command("egrep 'mirror.rackspace.com/ubuntu/? precise-security' /etc/apt/sources.list").and_return(false)
    end

    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04', step_into: ['rackspace_apt_repository']) do |node|
        node.set['rackspace_apt']['apt_installed'] = true
        node.set['rackspace_apt']['switch']['enable_rackspace_mirrors'] = true
      end.converge(described_recipe)
    end

    it 'sets up rackspace repos (ubuntu)' do
      expect(chef_run).to add_rackspace_apt_repository('mirror.rackspace.com-ubuntu-precise')
      expect(chef_run).to add_rackspace_apt_repository('mirror.rackspace.com-ubuntu-precise-updates')
      expect(chef_run).to add_rackspace_apt_repository('mirror.rackspace.com-ubuntu-precise-backports')
      expect(chef_run).to add_rackspace_apt_repository('mirror.rackspace.com-ubuntu-precise-security')
    end
  end

  context 'rackspace already appear in sources.list (ubuntu)' do
    before do
      stub_command("egrep 'mirror.rackspace.com/ubuntu/? precise' /etc/apt/sources.list").and_return(true)
      stub_command("egrep 'mirror.rackspace.com/ubuntu/? precise-updates' /etc/apt/sources.list").and_return(true)
      stub_command("egrep 'mirror.rackspace.com/ubuntu/? precise-backports' /etc/apt/sources.list").and_return(true)
      stub_command("egrep 'mirror.rackspace.com/ubuntu/? precise-security' /etc/apt/sources.list").and_return(true)
    end

    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04', step_into: ['rackspace_apt_repository']) do |node|
        node.set['rackspace_apt']['apt_installed'] = true
        node.set['rackspace_apt']['switch']['enable_rackspace_mirrors'] = true
      end.converge(described_recipe)
    end

    it 'does NOT set up rackspace repos (ubuntu)' do
      expect(chef_run).to_not add_rackspace_apt_repository('mirror.rackspace.com-ubuntu-precise')
      expect(chef_run).to_not add_rackspace_apt_repository('mirror.rackspace.com-ubuntu-precise-updates')
      expect(chef_run).to_not add_rackspace_apt_repository('mirror.rackspace.com-ubuntu-precise-backports')
      expect(chef_run).to_not add_rackspace_apt_repository('mirror.rackspace.com-ubuntu-precise-security')
    end
  end

  context 'rackspace mirrors enabled - ubuntu - rackspace in sources.list' do
    before do
      stub_command("egrep 'mirror.rackspace.com/debian/? wheezy' /etc/apt/sources.list").and_return(false)
      stub_command("egrep 'mirror.rackspace.com/debian-security/? wheezy/updates' /etc/apt/sources.list").and_return(false)
      stub_command("egrep 'mirror.rackspace.com/debian/? wheezy-backports' /etc/apt/sources.list").and_return(false)
    end

    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'debian', version: '7.2', step_into: ['rackspace_apt_repository']) do |node|
        node.set['rackspace_apt']['apt_installed'] = true
        node.set['rackspace_apt']['switch']['enable_rackspace_mirrors'] = true
      end.converge(described_recipe)
    end

    it 'sets up rackspace repos (debian)' do
      expect(chef_run).to add_rackspace_apt_repository('mirror.rackspace.com-debian-wheezy')
      expect(chef_run).to add_rackspace_apt_repository('mirror.rackspace.com-debian-security-wheezy-updates')
      expect(chef_run).to add_rackspace_apt_repository('mirror.rackspace.com-debian-wheezy-backports')
    end
  end

  context 'remove sources.list' do
    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['rackspace_apt']['apt_installed'] = true
        node.set['rackspace_apt']['switch']['delete_sources_list'] = true
      end.converge(described_recipe)
    end

    it 'deletes /etc/apt/sources.list' do
      expect(chef_run).to delete_file('/etc/apt/sources.list')
    end
  end

  context 'user defined a repo' do
    before do
      stub_command("egrep 'apt.opscode.com/? precise-0.10' /etc/apt/sources.list").and_return(false)
    end

    let(:chef_run) do
      ChefSpec::Runner.new(step_into: ['rackspace_apt_repository']) do |node|
        node.set['rackspace_apt']['apt_installed'] = true
        node.set['rackspace_apt']['repos']['apt.opscode.com']['precise-0.10'] = %w{main testing}
      end.converge(described_recipe)
    end

    it 'sets up rackspace LWRPs (ubuntu)' do
      expect(chef_run).to add_rackspace_apt_repository('apt.opscode.com-precise-0.10')
    end
  end
end
