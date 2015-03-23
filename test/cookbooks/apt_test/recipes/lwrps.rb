#
# Cookbook Name:: apt_test
# Recipe:: lwrps
#
# Copyright 2012, Chef Software, Inc.
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

include_recipe 'apt'

# Apt Repository
apt_repository 'juju' do
  uri 'http://ppa.launchpad.net/juju/stable/ubuntu'
  components ['main']
  distribution 'trusty'
  key 'C8068B11'
  keyserver 'keyserver.ubuntu.com'
  action :add
end

# PPA Repository
apt_repository 'rust' do
  uri 'ppa:hansjorg/rust'
  distribution node['lsb']['codename']
  not_if { node['platform'] == 'debian' }
end

# Apt Repository with arch
apt_repository 'cloudera' do
  uri 'http://archive.cloudera.com/cdh4/ubuntu/precise/amd64/cdh'
  arch 'amd64'
  distribution 'precise-cdh4'
  components ['contrib']
  key 'http://archive.cloudera.com/debian/archive.key'
  action :add
end

# Apt repository and install a package it contains
apt_repository 'nginx' do
  uri "http://nginx.org/packages/#{node['platform']}"
  distribution node['lsb']['codename']
  components ['nginx']
  key 'http://nginx.org/keys/nginx_signing.key'
  deb_src true
end

package 'nginx-debug' do
  action :upgrade
end

# Apt Preferences
apt_preference 'chef' do
  pin 'version 10.16.2-1'
  pin_priority '700'
end

# Preference file renaming
file '/etc/apt/preferences.d/wget' do
  action :touch
end

apt_preference 'wget' do
  pin 'version 1.13.4-3'
end

# COOK-2338
apt_preference 'dotdeb' do
  glob '*'
  pin 'origin packages.dotdeb.org '
  pin_priority '700'
end
