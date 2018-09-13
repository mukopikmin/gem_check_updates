# frozen_string_literal: true

module GemCheckUpdates
  class Runner
    def self.run(argv)
      options = parse_options(argv)
      gemfile = Gemfile.new(options[:file])

      if options[:apply]
        begin
          gemfile.backup
          gemfile.update
          gemfile.remove_backup

          print GemCheckUpdates::Message.update_completed(gemfile)
        rescue StandardError => e
          gemfile.restore

          print e.message.red
        end
      else
        print GemCheckUpdates::Message.updatable_gems(gemfile)
      end
    end

    def self.parse_options(argv)
      options = {
        file: './Gemfile',
        apply: false,
        # keep_backup: false
      }

      OptionParser.new do |opt|
        opt.version = GemCheckUpdates::VERSION

        opt.on('-f Gemfile', '--file', "Path to Gemfile (default: #{options[:file]})") { |v| options[:file] = v }
        opt.on('-a', '--apply', "Apply updates (default: #{options[:apply]})") { |v| options[:apply] = v }

        opt.parse!(argv)
      end

      options
    end
  end
end
