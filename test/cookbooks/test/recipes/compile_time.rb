# frozen_string_literal: true

apt_config 'default' do
  periodic_update_min_delay 0
  compile_time_update true
  compile_time true
end
