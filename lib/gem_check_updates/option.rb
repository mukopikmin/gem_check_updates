# frozen_string_literal: true

module GemCheckUpdates
  class Option
    attr_reader :apply
    attr_accessor :file, :major, :minor, :patch

    def initialize(file: './Gemfile')
      @file = file
      @apply = false
      @major = true
      @minor = false
      @patch = false
    end

    def self.parse(argv)
      option = new

      OptionParser.new do |opt|
        opt.version = GemCheckUpdates::VERSION

        opt.on('-f Gemfile', '--file', "Path to Gemfile (default: #{option.file})") { |v| option.file = v }
        opt.on('-a', '--apply', "Apply updates (default: #{option.apply})") { |v| option.apply = v }
        opt.on('--major', "Update major version (default: #{option.major})") do |v|
          option.major = v
          option.minor = !v
          option.patch = !v
        end
        opt.on('--minor', "Update minor version (default: #{option.minor})") do |v|
          option.major = !v
          option.minor = v
          option.patch = !v
        end
        opt.on('--patch', "Update patch version (default: #{option.patch})") do |v|
          option.major = !v
          option.minor = !v
          option.patch = v
        end

        opt.parse!(argv)
      end

      option
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
