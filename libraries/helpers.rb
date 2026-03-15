# frozen_string_literal: true

module Apt
  module Helpers
    def apt_installed?
      !apt_which('apt-get').nil?
    end

    def apt_which(cmd)
      ENV['PATH'] = '' if ENV['PATH'].nil?
      paths = ENV['PATH'].split(::File::PATH_SEPARATOR) + %w(/bin /usr/bin /sbin /usr/sbin)

      paths.each do |path|
        possible = ::File.join(path, cmd)
        return possible if ::File.executable?(possible)
      end

      nil
    end

    def apt_codename
      node.dig('lsb', 'codename') || 'stable'
    end
  end
end
