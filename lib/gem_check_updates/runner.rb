module GemCheckUpdates
  class Runner
    def self.run(argv)
      options = parse_options(argv)
      gemfile = Gemfile.new(options[:file])

      if options[:apply]
        gemfile.update
      else
        gemfile.show_version_diff
      end
    end

    def self.parse_options(argv)
      options = {
        file: './Gemfile',
        apply: false,
        # major: false,
        # minor: false,
        # patch: false
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
