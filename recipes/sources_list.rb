
platform = node['platform']

repo = 'archive'
if node['apt']['sources_list']['enable_cdn']
  repo = 'cdn'
end

template_hash = {
  :codename => node['lsb']['codename'],
  :sources => node['apt']['sources_list']['include_source_packages'],
  :archive_url => node['apt']['sources_list'][platform]["#{repo}_url"],
  :security_url => node['apt']['sources_list'][platform]['security_url'],
  :components => node['apt']['sources_list'][platform]['components'],
  :updates => node['apt']['sources_list'][platform]['enable_updates'],
  :backports => node['apt']['sources_list'][platform]['enable_backports'],
}

if node['platform'] == 'ubuntu'
  template_hash[:partners] = node['apt']['sources_list']['ubuntu']['enable_partners']
  template_hash[:partners_url] = node['apt']['sources_list']['ubuntu']['partners_url']
end

template "/etc/apt/sources.list" do
    mode 00644
    variables template_hash
    owner 'root'
    group 'root'
    notifies :run, 'execute[apt-get update]', :immediately
    source "sources.list.erb"
end
