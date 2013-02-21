class Chef
  class Provider
    class Package
      class Apt

        def install_package(name, version)
          rescued = false
          begin
            # Keep all the things in the block for retry
            Chef::Log.debug("#{@new_resource} Candidate Version: #{version}")
            package_name = "#{name}=#{version}"
            package_name = name if @is_virtual_package

            run_command_with_systems_locale(
              :command => "apt-get -q -y#{expand_options(default_release_options)}#{expand_options(@new_resource.options)} install #{package_name}",
              :environment => {
                "DEBIAN_FRONTEND" => "noninteractive"
              }
            )
          rescue Exception => e
            if rescued == false
              rescued = true
              update_aptitude_cache
              load_current_resource
              Chef::Log.debug("#{@new_resource} Old Candidate Version: #{version}")
              version = @candidate_version
              Chef::Log.debug("#{@new_resource} New Candidate Version: #{version}")
              retry
            else
              raise Chef::Exceptions::Exec, e.message
            end
          end
        end

        def update_aptitude_cache
          Chef::Log.info("#{@new_resource} Updating Aptitude Cache")
          run_command_with_systems_locale(
            :command => "apt-get update",
            :environment => {
              "DEBIAN_FRONTEND" => "noninteractive"
            }
          )
        end

      end
    end
  end
end