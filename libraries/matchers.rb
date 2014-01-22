# Matchers for chefspec 3

if defined?(ChefSpec)
  def add_rackspace_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_apt_repository, :add, resource_name)
  end

  def remove_rackspace_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_apt_repository, :remove, resource_name)
  end

  def add_rackspace_apt_globalconfig(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_apt_globalconfig, :add, resource_name)
  end

  def remove_rackspace_apt_globalconfig(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rackspace_apt_globalconfig, :remove, resource_name)
  end
end
