# frozen_string_literal: true

module GemCheckUpdates
  class Message
    NAME_MAX_LENGTH = 30
    VERSION_MAX_LENGTH = 15

    def self.out(str)
      return if ENV['RACK_ENV'] == 'test'

      print str
    end

    def self.updatable_gems(gemfile, scope)
      out <<~VERSIONS
        Checking #{scope.green} updates are completed.

        You can update following newer gems.
        If you want to apply these updates, run command with option #{'--apply'.green}.

        #{'Running with --apply option will overwrite your Gemfile.'.red}

        #{gems_version_diff(gemfile)}


      VERSIONS
    end

    def self.update_completed(gemfile, scope)
      out <<~VERSIONS
        Checking #{scope.green} updates are completed.

        Following gems have been updated!

        #{gems_version_diff(gemfile)}


      VERSIONS
    end

    def self.gems_version_diff(gemfile)
      gemfile.gems
             .select(&:update_available?)
             .map do |gem|
        "    #{gem.name.ljust(NAME_MAX_LENGTH)}" +
          "\"#{gem.version_range} #{gem.current_version}\"".ljust(VERSION_MAX_LENGTH) +
          '→'.center(7) +
          "\"#{gem.version_range} #{gem.latest_version.green}\""
      end .join("\n")
    end
  end
end
