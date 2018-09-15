# frozen_string_literal: true

module GemCheckUpdates
  class Runner
    def self.run(argv)
      options = parse_options(argv)
      gemfile = Gemfile.new(options[:file], update_scope(options))

      if options[:apply]
        begin
          gemfile.backup
          gemfile.update
          gemfile.remove_backup

          GemCheckUpdates::Message.update_completed(gemfile)
        rescue StandardError => e
          gemfile.restore

          print e.message.red
        end
      else
        GemCheckUpdates::Message.updatable_gems(gemfile)
      end
    end

    def self.parse_options(argv)
      options = {
        file: './Gemfile',
        apply: false,
        major: true,
        minor: true,
        patch: true
        # keep_backup: false,
        # verbose: false
      }

      OptionParser.new do |opt|
        opt.version = GemCheckUpdates::VERSION

        opt.on('-f Gemfile', '--file', "Path to Gemfile (default: #{options[:file]})") { |v| options[:file] = v }
        opt.on('-a', '--apply', "Apply updates (default: #{options[:apply]})") { |v| options[:apply] = v }
        opt.on('--major', "Update major version (default: #{options[:major]})") { |v| options[:major] = v }
        opt.on('--minor', "Update minor version (default: #{options[:minor]})") { |v| options[:minor] = v }
        opt.on('--patch', "Update patch version (default: #{options[:patch]})") { |v| options[:patch] = v }

        opt.parse!(argv)
      end

      options
    end

    def self.update_scope(options)
      if options[:major]
        GemCheckUpdates::VersionScope::MAJOR
      elsif options[:minor]
        GemCheckUpdates::VersionScope::MINOR
      elsif options[:patch]
        GemCheckUpdates::VersionScope::PATCH
      else
        GemCheckUpdates::VersionScope::MAJOR
      end
    end
  end
end
