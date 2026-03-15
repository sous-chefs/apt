# frozen_string_literal: true

provides :apt_cacher_ng
unified_mode true

property :cacher_dir, String, default: '/var/cache/apt-cacher-ng'
property :cacher_port, [Integer, String], default: 3142
property :cacher_interface, [String, nil]

default_action :create

action :create do
  package 'apt-cacher-ng'

  directory new_resource.cacher_dir do
    owner 'apt-cacher-ng'
    group 'apt-cacher-ng'
    mode '0755'
  end

  template '/etc/apt-cacher-ng/acng.conf' do
    cookbook 'apt'
    source 'acng.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    variables(
      cacher_dir: new_resource.cacher_dir,
      cacher_port: new_resource.cacher_port,
      cacher_interface: new_resource.cacher_interface
    )
    notifies :restart, 'service[apt-cacher-ng]', :immediately
  end

  service 'apt-cacher-ng' do
    action %i(enable start)
  end
end

action :delete do
  service 'apt-cacher-ng' do
    action %i(stop disable)
    only_if { ::File.exist?('/lib/systemd/system/apt-cacher-ng.service') || ::File.exist?('/usr/lib/systemd/system/apt-cacher-ng.service') }
  end

  file '/etc/apt-cacher-ng/acng.conf' do
    action :delete
  end

  directory new_resource.cacher_dir do
    recursive true
    action :delete
  end

  package 'apt-cacher-ng' do
    action :remove
  end
end
