# frozen_string_literal: true

module GemCheckUpdates
  class Gemfile
    attr_reader :option, :file_backup, :gems

    def initialize(option = GemCheckUpdates::Option.new)
      @option = option
      @file_backup = "#{option.file}.backup"
      @gems = parse(option.update_scope)
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
      gems = Bundler::Definition.build(@option.file, nil, nil).dependencies.map do |gem|
        GemCheckUpdates::Message.out('.')

        name = gem.name
        version_range, version = gem.requirements_list.first.split(' ')

        Gem.new(name: name,
                current_version: version,
                version_range: version_range,
                update_scope: update_scope)
      end

      GemCheckUpdates::Message.out("\n\n")

      gems
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
