#
# Cookbook Name:: rackspace_apt
# Recipe:: rackspace_mirrors
#
# Copyright 2014, Rackspace, US Inc.
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

# On systems where apt is not installed, the resources in this recipe are not
# executed. However, they _must_ still be present in the resource collection
# or other cookbooks which notify these resources will fail on non-apt-enabled
# systems.

case node[:platform]
when 'ubuntu'
  case node[:platform_version]
  when '12.04'
    node.default[:rackspace_apt][:supported_platforms][:ubuntu][:repos][:"#{node[:platform]}_#{node[:lsb][:codename]}"] = [:main, :restricted, :universe, :multiverse]
    node.default[:rackspace_apt][:supported_platforms][:ubuntu][:repos][:"#{node[:platform]}_#{node[:lsb][:codename]}-updates"] = [:main, :restricted, :universe, :multiverse]   
    node.default[:rackspace_apt][:supported_platforms][:ubuntu][:repos][:"#{node[:platform]}_#{node[:lsb][:codename]}-backports"] = [:main, :restricted, :universe, :multiverse]
    node.default[:rackspace_apt][:supported_platforms][:ubuntu][:repos][:"#{node[:platform]}_#{node[:lsb][:codename]}-security"] = [:main, :restricted, :universe, :multiverse]
  end
when 'debian'
  case node[:platform_version]
  when '7.2'
    node.default[:rackspace_apt][:supported_platforms][:debian][:repos][:"#{node[:platform]}_#{node[:lsb][:codename]}"] = [:main]
    node.default[:rackspace_apt][:supported_platforms][:debian][:repos][:"#{node[:platform]}-security_#{node[:lsb][:codename]}/updates"] = [:main]
    node.default[:rackspace_apt][:supported_platforms][:debian][:repos][:"#{node[:platform]}_#{node[:lsb][:codename]}-backports"] = [:main]
  end
end

# only add repos if running a supported platform  
if node[:rackspace_apt][:supported_platforms]
  node[:rackspace_apt][:supported_platforms][node[:platform]][:repos].each do |dist, components|
    rackspace_apt_repository "rackspace-#{dist}".gsub("/","-").gsub("_","-") do
      uri "http://mirror.rackspace.com/#{dist.split("_")[0]}/"
      distribution dist.split("_")[1]
      components components
      deb_src :true 
      only_if { node[:rackspace_apt][:apt_installed] }
      action :add
    end
  end
end
