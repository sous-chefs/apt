define :apt_conf, :level => 99, :options => {}, :override_filename => nil, :template => nil, :cookbook => nil do
  file "/etc/apt/apt.conf.d/#{params[:level]}#{params[:override_filename] || params[:name]}" do
    owner 'root'
    group 'root'
    mode 0644
    content params[:options].map{|k,v| "#{k} \"#{v}\""}.join("\n")
  end
end
