if defined?(ChefSpec)

  #################
  # apt_preference
  #################

  def add_apt_preference(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_preference, :add, resource_name)
  end

  def remove_apt_preference(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_preference, :remove, resource_name)
  end

  #################
  # apt_repository
  #################

  def add_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :add, resource_name)
  end

  def remove_apt_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :remove, resource_name)
  end

  #################
  # apt_update
  #################

  def update_apt_update(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_update, :update, resource_name)
  end

  def periodic_apt_update(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:apt_update, :periodic, resource_name)
  end
end
