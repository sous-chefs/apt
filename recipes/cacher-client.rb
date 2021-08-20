#
# Cookbook:: apt
# Recipe:: cacher-client
#
# Copyright:: 2011-2019, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# remove Acquire::http::Proxy lines from /etc/apt/apt.conf since we use 01proxy
# these are leftover from preseed installs
execute 'Remove proxy from /etc/apt/apt.conf' do
  command "sed --in-place '/^Acquire::http::Proxy/d' /etc/apt/apt.conf"
  only_if 'grep Acquire::http::Proxy /etc/apt/apt.conf'
end

if node['apt']['cacher_client']['cacher_server'].empty?
  Chef::Log.warn("No cache server defined in node['apt']['cacher_client']['cacher_server']. Not setting up caching")
  file '/etc/apt/apt.conf.d/01proxy' do
    action :delete
  end
else
  apt_update 'update for notification' do
    action :nothing
  end

  template '/etc/apt/apt.conf.d/01proxy' do
    source '01proxy.erb'
    mode '644'
    variables(
      server: node['apt']['cacher_client']['cacher_server']
    )
    notifies :update, 'apt_update[update for notification]', :immediately
  end
end

include_recipe 'apt::default' # rubocop: disable Chef/Modernize/IncludingAptDefaultRecipe
