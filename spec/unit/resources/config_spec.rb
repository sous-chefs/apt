# frozen_string_literal: true

require 'spec_helper'

describe 'apt_config' do
  step_into :apt_config
  platform 'ubuntu', '22.04'

  before do
    allow(::File).to receive(:executable?).and_return(true)
  end

  recipe do
    apt_config 'default'
  end

  it { is_expected.to periodic_apt_update('periodic').with(frequency: 86_400) }
  it { is_expected.to create_file('/var/lib/apt/periodic/update-success-stamp') }
  it { is_expected.to create_directory('/var/cache/local') }
  it { is_expected.to create_directory('/var/cache/local/preseeding') }
  it { is_expected.to install_package(%w(apt-transport-https gnupg dirmngr)) }
  it { is_expected.to render_file('/etc/apt/apt.conf.d/10recommends').with_content('APT::Install-Recommends "1";') }
end
