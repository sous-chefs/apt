# frozen_string_literal: true

require 'spec_helper'

describe 'apt_unattended_upgrades' do
  step_into :apt_unattended_upgrades
  platform 'ubuntu', '22.04'

  recipe do
    apt_unattended_upgrades 'default' do
      enable true
      dpkg_options ['--force-confold']
      mail 'ops@example.com'
    end
  end

  it { is_expected.to create_directory('/var/cache/local/preseeding') }
  it { is_expected.to create_template('/var/cache/local/preseeding/unattended-upgrades.seed').with(mode: '0600') }
  it { is_expected.to install_package('unattended-upgrades') }
  it { is_expected.to install_package('bsd-mailx') }
  it { is_expected.to render_file('/etc/apt/apt.conf.d/20auto-upgrades').with_content('APT::Periodic::Unattended-Upgrade "1";') }
  it { is_expected.to render_file('/etc/apt/apt.conf.d/50unattended-upgrades').with_content(/"--force-confold";/) }
end
