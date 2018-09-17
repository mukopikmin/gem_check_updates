# frozen_string_literal: true

module GemCheckUpdates
  class Runner
    def self.run(argv)
      options = Option.parse(argv)
      gemfile = Gemfile.new(options.file, options.update_scope)

      if options.apply
        begin
          gemfile.backup
          gemfile.update
          gemfile.remove_backup

          GemCheckUpdates::Message.update_completed(gemfile, options.update_scope)
        rescue StandardError => e
          gemfile.restore

          GemCheckUpdates::Message.out(e.message.red)
        end
      else
        GemCheckUpdates::Message.updatable_gems(gemfile, options.update_scope)
      end
    end
  end
end
