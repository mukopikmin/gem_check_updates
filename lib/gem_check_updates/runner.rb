# frozen_string_literal: true

module GemCheckUpdates
  class Runner
    def self.run(argv)
      options = parse_options(argv)
      scope = update_scope(options)
      gemfile = Gemfile.new(options[:file], scope)

      if options[:apply]
        begin
          gemfile.backup
          gemfile.update
          gemfile.remove_backup

          GemCheckUpdates::Message.update_completed(gemfile, scope)
        rescue StandardError => e
          gemfile.restore

          print e.message.red
        end
      else
        GemCheckUpdates::Message.updatable_gems(gemfile, scope)
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
        opt.on('--major', "Update major version (default: #{options[:major]})") do |v|
          options[:major] = v
          options[:minor] = !v
          options[:patch] = !v
        end
        opt.on('--minor', "Update minor version (default: #{options[:minor]})") do |v|
          options[:major] = !v
          options[:minor] = v
          options[:patch] = !v
        end
        opt.on('--patch', "Update patch version (default: #{options[:patch]})") do |v|
          options[:major] = !v
          options[:minor] = !v
          options[:patch] = v
        end

        opt.parse!(argv)
      end

      options
    end

    def self.update_scope(options)
      if !options[:major] && options[:minor]
        GemCheckUpdates::VersionScope::MINOR
      elsif !options[:major] && !options[:minor] && options[:patch]
        GemCheckUpdates::VersionScope::PATCH
      else
        GemCheckUpdates::VersionScope::MAJOR
      end
    end
  end
end
