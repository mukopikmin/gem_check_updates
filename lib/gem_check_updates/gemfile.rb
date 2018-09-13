# frozen_string_literal: true

module GemCheckUpdates
  class Gemfile
    attr_reader :file, :file_backup, :gems

    def initialize(file)
      @file = file
      @file_backup = "#{@file}.backup"
      @gems = parse
    end

    def backup
      FileUtils.cp(@file, @file_backup)
    end

    def restore
      FileUtils.mv(@file_backup, @file)
    end

    def remove_backup
      FileUtils.rm(@file_backup)
    end

    def parse
      gems = Bundler::Definition.build(@file, nil, nil).dependencies.map do |gem|
        print '.'

        name = gem.name
        version_range, version = gem.requirements_list.first.split(' ')

        Gem.new(name: name,
                current_version: version,
                version_range: version_range)
      end

      print "\n\n"

      gems
    end

    def update
      File.open(@file_backup) do |current|
        File.open(@file, 'w') do |updated|
          current.each_line do |line|
            if matcher = line.match(/gem ['"](.+?)['"]\s*,\s*['"][>=|~>]*\s+(.+?)['"]/)
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
end
