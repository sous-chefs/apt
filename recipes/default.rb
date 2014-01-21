#
# Cookbook Name:: rackspace_apt
# Recipe:: default
#
# Copyright 2014, Rackspace, US Inc.
# Copyright 2009, Bryan McLellan <btm@loftninjas.org>
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

# On systems where apt is not installed, the resources in this recipe are not
# executed. However, they _must_ still be present in the resource collection
# or other cookbooks which notify these resources will fail on non-apt-enabled
# systems.

node.default['rackspace_apt']['apt_installed'] = true

unless apt_installed?
  Chef::Log.debug 'apt is not installed. Apt-specific resources will not be executed.'
  node.default['rackspace_apt']['apt_installed'] = false
end

include_recipe 'rackspace_apt::repos' if node['rackspace_apt']['apt_installed']

# Run apt-get update to create the stamp file
execute 'apt-get-update' do
  command 'apt-get update'
  ignore_failure true
  only_if { node['rackspace_apt']['apt_installed'] }
  not_if { ::File.exists?('/var/lib/apt/periodic/update-success-stamp') }
end

# For other recipes to call to force an update
execute 'apt-get update' do
  command 'apt-get update'
  ignore_failure true
  only_if { node['rackspace_apt']['apt_installed'] }
  action :nothing
end

# Automatically remove packages that are no longer needed for dependencies
execute 'apt-get autoremove' do
  command 'apt-get -y autoremove'
  only_if { node['rackspace_apt']['apt_installed'] }
  action :nothing
end

# Automatically remove .deb files for packages no longer on your system
execute 'apt-get autoclean' do
  command 'apt-get -y autoclean'
  only_if { node['rackspace_apt']['apt_installed'] }
  action :nothing
end

# provides /var/lib/apt/periodic/update-success-stamp on apt-get update
package 'update-notifier-common' do
  notifies :run, 'execute[apt-get-update]', :immediately
  only_if { node['rackspace_apt']['apt_installed'] }
end

execute 'apt-get-update-periodic' do
  command 'apt-get update'
  ignore_failure true
  only_if do
    node['rackspace_apt']['apt_installed'] &&
    ::File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
    ::File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86_400
  end
end

%w{/var/cache/local /var/cache/local/preseeding}.each do |dirname|
  directory dirname do
    owner 'root'
    group 'root'
    mode  00755
    action :create
    only_if { node['rackspace_apt']['apt_installed'] }
  end
end
