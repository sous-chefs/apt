#
# Cookbook Name:: rackspace_apt
# Recipe:: cacher-client
#
# Copyright 2014, Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class ::Chef::Recipe
  include ::RackspaceApt
end

# remove Acquire::http::Proxy lines from /etc/apt/apt.conf since we use 01proxy
# these are leftover from preseed installs
execute 'Remove proxy from /etc/apt/apt.conf' do
  command 'sed --in-place "/^Acquire::http::Proxy/d" /etc/apt/apt.conf'
  only_if 'grep Acquire::http::Proxy /etc/apt/apt.conf'
end

servers = []
if node['rackspace_apt']['config']['cacher_server']
  if node['rackspace_apt']['config']['cacher_client']['cacher_ipaddress']
    cacher = Chef::Node.new
    cacher.default.name = node['rackspace_apt']['config']['cacher_client']['cacher_ipaddress']
    cacher.default.ipaddress = node['rackspace_apt']['config']['cacher_client']['cacher_ipaddress']
    cacher.default.rackspace_apt.config.cacher_server.Port.value = node['rackspace_apt']['config']['cacher_server']['Port']['value']
    cacher.default.rackspace_apt.switch.cacher_server.cacher_interface = node['rackspace_apt']['switch']['cacher_server']['cacher_interface']
    servers << cacher
  elsif node['rackspace_apt']['switch']['caching_server']
    node.override['rackspace_apt']['switch']['compiletime'] = false
    servers << node
  end
end

unless Chef::Config['solo'] || servers.length > 0
  query = 'rackspace_apt_switch_caching_server:true'
  query += " AND chef_environment:#{node.chef_environment}" if node['rackspace_apt']['switch']['cacher_client']['restrict_environment']
  Chef::Log.debug("rackspace_apt::cacher-client searching for '#{query}'")
  servers += search(:node, query)
end

if servers.length > 0
  Chef::Log.info("apt-cacher-ng server found on #{servers[0]}.")
  if servers[0]['rackspace_apt']['switch']['cacher_server']['cacher_interface']
    cacher_ipaddress = interface_ipaddress(servers[0], servers[0]['rackspace_apt']['switch']['cacher_server']['cacher_interface'])
  else
    cacher_ipaddress = servers[0].ipaddress
  end
  t = template '/etc/apt/apt.conf.d/01proxy' do
    cookbook node['rackspace_apt']['templates_cookbook']
    source '01proxy.erb'
    owner 'root'
    group 'root'
    mode 00644
    variables(
      proxy: cacher_ipaddress,
      port: servers[0]['rackspace_apt']['config']['cacher_server']['Port']['value'],
      bypass: node['rackspace_apt']['config']['cacher_client']['cache_bypass']
      )
    action(node['rackspace_apt']['switch']['compiletime'] ? :nothing : :create)
    notifies :run, 'execute[apt-get update]', :immediately
  end
  t.run_action(:create) if node['rackspace_apt']['switch']['compiletime']
else
  Chef::Log.info('No apt-cacher-ng server found.')
  file '/etc/apt/apt.conf.d/01proxy' do
    action :delete
  end
end

include_recipe 'rackspace_apt::default'
