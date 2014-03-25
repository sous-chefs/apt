
platform = node['platform']
version = node['platform_version']

codename = node['apt']['version_to_codename'][platform][version]
mirror_id = node['apt']['mirrors']['preferred']
mirror_url = node['apt']['mirrors'][platform][mirror_id]

template "/etc/apt/sources.list" do
    source "sources.list.erb"
    variables({
        :codename => codename,
        :mirror => mirror_url
    })
    notifies :run, 'execute[apt-get update]', :immediately
end
