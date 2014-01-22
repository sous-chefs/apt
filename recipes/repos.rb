#
# Cookbook Name:: rackspace_apt
# Recipe:: rackspace_mirrors
#
# Copyright 2014, Rackspace, US Inc.
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     www.apache.org/licenses/LICENSE-2.0
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

if node['rackspace_apt']['switch']['enable_rackspace_mirrors']
  case node['platform']
  when 'ubuntu'
    case node['platform_version']
    when '12.04'
      node.default['rackspace_apt']['repos']['mirror.rackspace.com/ubuntu']['precise'] = %w{main restricted universe multiverse}
      node.default['rackspace_apt']['repos']['mirror.rackspace.com/ubuntu']['precise-updates'] = %w{main restricted universe multiverse}
      node.default['rackspace_apt']['repos']['mirror.rackspace.com/ubuntu']['precise-backports'] = %w{main restricted universe multiverse}
      node.default['rackspace_apt']['repos']['mirror.rackspace.com/ubuntu']['precise-security'] = %w{main restricted universe multiverse}
    end
  when 'debian'
    case node['platform_version']
    when '7.2'
      node.default['rackspace_apt']['repos']['mirror.rackspace.com/debian']['wheezy'] = %w{main}
      node.default['rackspace_apt']['repos']['mirror.rackspace.com/debian-security']['wheezy/updates'] = %w{main}
      node.default['rackspace_apt']['repos']['mirror.rackspace.com/debian']['wheezy-backports'] = %w{main}
    end
  end
end

# only add repos if running a supported platform, although end user may also define repos and they'll be defined here
if node['rackspace_apt']['repos']
  node['rackspace_apt']['repos'].each_key do |repo|
    node['rackspace_apt']['repos'][repo].each do |dist, components|
      rackspace_apt_repository "#{repo}-#{dist}".gsub('/', '-') do
        uri "http://#{repo}"
        distribution dist
        components components
        deb_src :true
        only_if { node['rackspace_apt']['apt_installed'] }
        not_if "egrep '#{repo}/? #{dist}' /etc/apt/sources.list" # do not define duplicate entries
        action :add
      end
    end
  end
end

file '/etc/apt/sources.list' do
  action :delete
  only_if { node['rackspace_apt']['switch']['delete_sources_list'] }
end
