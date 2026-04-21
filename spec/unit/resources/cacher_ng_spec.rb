# frozen_string_literal: true

require 'spec_helper'

describe 'apt_cacher_ng' do
  step_into :apt_cacher_ng
  platform 'ubuntu', '22.04'

  recipe do
    apt_cacher_ng 'default' do
      cacher_dir '/tmp/apt-cacher'
      cacher_port 9876
      cacher_interface '0.0.0.0'
    end
  end

  it { is_expected.to install_package('apt-cacher-ng') }
  it { is_expected.to create_directory('/tmp/apt-cacher').with(owner: 'apt-cacher-ng', group: 'apt-cacher-ng') }
  it { is_expected.to render_file('/etc/apt-cacher-ng/acng.conf').with_content('CacheDir: /tmp/apt-cacher') }
  it { is_expected.to render_file('/etc/apt-cacher-ng/acng.conf').with_content('Port:9876') }
  it { is_expected.to render_file('/etc/apt-cacher-ng/acng.conf').with_content('BindAddress: 0.0.0.0') }
  it { is_expected.to enable_service('apt-cacher-ng') }
  it { is_expected.to start_service('apt-cacher-ng') }
end
