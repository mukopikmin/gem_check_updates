# frozen_string_literal: true

module GemCheckUpdates
  class Runner
    def self.run(argv)
      option = Option.parse(argv)
      gemfile = Gemfile.new(option)

      if option.apply
        begin
          gemfile.backup
          gemfile.update
          gemfile.remove_backup

          GemCheckUpdates::Message.update_completed(gemfile)
        rescue StandardError => e
          gemfile.restore

          GemCheckUpdates::Message.out(e.message.red)
        end
      else
        GemCheckUpdates::Message.updatable_gems(gemfile)
      end
    end
  end
end
