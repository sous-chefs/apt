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

require File.expand_path('../support/helpers', __FILE__)

describe 'apt_test::sources_list' do
  include Helpers::AptTest

  describe 'creates sources.list and has proper permissions' do
    let(:config) { file("/etc/apt/sources.list") }
    it { config.must_have(:mode, "644") }
    it { config.must_have(:owner, "root") }
    it { config.must_have(:group, "root") }
    it { config.must_match /^# Managed by Chef$/}
    it { config.must_match /(lucid|precise|trusty|utopic|vivid|wheezy)/}
  end

end
