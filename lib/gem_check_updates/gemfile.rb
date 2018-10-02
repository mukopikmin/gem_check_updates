# frozen_string_literal: true

module GemCheckUpdates
  class Gemfile
    RUBYGEMS_API = 'https://rubygems.org/api/v1/versions'
    CONCURRENCY = 5

    attr_reader :option
    attr_reader :file_backup
    attr_reader :gems

    def initialize(option = GemCheckUpdates::Option.new)
      @option = option
      @file_backup = "#{option.file}.backup"
      @gems = parse(option.update_scope)

      check_updates!
    end

    def backup
      FileUtils.cp(@option.file, @file_backup)
    end

    def restore
      FileUtils.mv(@file_backup, @option.file)
    end

    def remove_backup
      FileUtils.rm(@file_backup)
    end

    def parse(update_scope)
      Bundler::Definition.build(@option.file, nil, nil).dependencies.map do |gem|
        name = gem.name
        version_range, version_number = gem.requirements_list.first.split(' ')
        version = GemCheckUpdates::GemVersion.new(number: version_number)

        Gem.new(name: name,
                current_version: version,
                version_range: version_range,
                update_scope: update_scope)
      end
    end

    def check_updates!
      EventMachine.synchrony do
        EventMachine::Synchrony::FiberIterator.new(@gems, CONCURRENCY).each do |gem|
          http = EventMachine::HttpRequest.new("#{RUBYGEMS_API}/#{gem.name}.json").get
          response = JSON.parse(http.response)
          versions = response.map do |v| 
            number = v['number']
            pre_release = v['prerelease']

            GemCheckUpdates::GemVersion.new(number: number, pre_release: pre_release)
          end

          gem.versions = versions
          GemCheckUpdates::Message.out('.')
        end

        GemCheckUpdates::Message.out("\n\n")
        EventMachine.stop
      end

      @gems
    end

    def update
      gemfile_lines = []

      File.open(@option.file) do |current|
        current.each_line do |line|
          gemfile_lines << line
        end
      end

      File.open(@option.file, 'w') do |updated|
        gemfile_lines.each do |line|
          matcher = line.match(/gem ['"](.+?)['"]\s*,\s*['"][>=|~>]*\s+(.+?)['"]/)

          if matcher
            _, name, old_version = *matcher
            target = @gems.find { |gem| gem.name == name }

            line.gsub!(old_version, target.latest_version) unless target.nil?
          end

          updated.puts(line)
        end
      end
    end
  end
end
