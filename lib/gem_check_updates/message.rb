# frozen_string_literal: true

module GemCheckUpdates
  class Message
    def self.updatable_gems(gemfile)
      diff = gemfile.gems.map { |gem| "    #{gem.name} \"#{gem.version_range} #{gem.current_version}\" → \"#{gem.version_range} #{gem.latest_version.green}\"" }.join("\n")

      <<~VERSIONS
        Following gems can be updated.
        If you want to apply these updates, run command with option \'-a\'.
        #{'(Caution: This option will overwrite your Gemfile)'.red}

        #{diff}


      VERSIONS
    end

    def self.update_completed(gemfile)
      diff = gemfile.gems.map { |gem| "    #{gem.name} \"#{gem.version_range} #{gem.current_version}\" → \"#{gem.version_range} #{gem.latest_version.green}\"" }.join("\n")

      <<~VERSIONS
        Following gems have been updated!

        #{diff}


      VERSIONS
    end
  end
end
