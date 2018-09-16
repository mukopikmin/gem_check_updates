# frozen_string_literal: true

module GemCheckUpdates
  class Message
    def self.out(str)
      return if ENV['RACK_ENV'] == 'test'

      print str
    end

    def self.updatable_gems(gemfile, scope)
      out <<~VERSIONS
        Checking #{scope.green} updates are completed.

        You can update following newer gems.
        If you want to apply these updates, run command with option \'-a\'.
        #{'(Caution: This option will overwrite your Gemfile)'.red}

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
             .map { |gem| "    #{gem.name} \"#{gem.version_range} #{gem.current_version}\" → \"#{gem.version_range} #{gem.latest_version.green}\"" }.join("\n")
    end
  end
end
