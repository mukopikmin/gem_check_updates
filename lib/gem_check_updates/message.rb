# frozen_string_literal: true

module GemCheckUpdates
  class Message
    def self.out(str)
      return if ENV['RACK_ENV'] == 'test'

      print str
    end

    def self.updatable_gems(gemfile)
      out <<~EOS
        Checking #{gemfile.option.update_scope.green} updates are completed.

        You can update following newer gems.
        If you want to apply these updates, run command with option #{'--apply'.green}.

        #{'Running with --apply option will overwrite your Gemfile.'.red}

        #{gems_version_diff(gemfile)}


      EOS
    end

    def self.update_completed(gemfile)
      out <<~EOS
        Checking #{gemfile.option.update_scope.green} updates are completed.

        Following gems have been updated!

        #{gems_version_diff(gemfile)}


      EOS
    end

    def self.gems_version_diff(gemfile)
      gemfile.gems
             .select(&:update_available?)
             .map do |gem|
               name = gem.name
               current = "#{gem.version_range} #{gem.current_version}"
               latest = "#{gem.version_range} #{gem.highlighted_latest_version}"

               "    #{name.ljust(30)} #{current.ljust(15)} #{'→'.ljust(7)} #{latest}"
             end.join("\n")
    end
  end
end
