# frozen_string_literal: true

module GemCheckUpdates
  class Option
    attr_reader :apply
    attr_accessor :file, :major, :minor, :patch, :include_beta

    def initialize
      @file = './Gemfile'
      @apply = false
      @major = true
      @minor = false
      @patch = false
      @include_beta = false
    end

    def self.parse(argv)
      optionss = new

      OptionParser.new do |opt|
        opt.version = GemCheckUpdates::VERSION

        opt.on('-f Gemfile', '--file', "Path to Gemfile (default: #{options.file})") { |v| options.file = v }
        opt.on('-a', '--apply', "Apply updates (default: #{options.apply})") { |v| options.apply = v }
        opt.on('--major', "Update major version (default: #{options.major})") do |v|
          options.major = v
          options.minor = !v
          options.patch = !v
        end
        opt.on('--minor', "Update minor version (default: #{options.minor})") do |v|
          options.major = !v
          options.minor = v
          options.patch = !v
        end
        opt.on('--patch', "Update patch version (default: #{options.patch})") do |v|
          options.major = !v
          options.minor = !v
          options.patch = v
        end
        opt.on('-i', '--include-beta', "Check updates of beta release, including alpha or release candidate (Default: #{options.include_beta})")

        opt.parse!(argv)
      end

      options
    end

    def update_scope
      if !@major && @minor
        GemCheckUpdates::VersionScope::MINOR
      elsif !@major && !@minor && @patch
        GemCheckUpdates::VersionScope::PATCH
      else
        GemCheckUpdates::VersionScope::MAJOR
      end
    end
  end
end
