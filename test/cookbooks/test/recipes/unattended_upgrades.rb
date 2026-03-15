# frozen_string_literal: true

apt_config 'default'

apt_unattended_upgrades 'default' do
  enable true
  allowed_origins []
  dpkg_options ['--force-confold']
end
