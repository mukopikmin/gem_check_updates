module GemCheckUpdates
  class Gemfile
    def initialize(file)
      @file = file
      @gems = self.class.parse(file)
    end

    def file_backup
      "#{@file}.backup"
    end

    def backup
      FileUtils.cp(@file, file_backup)
    end

    def restore
      FileUtils.mv(file_backup, @file)
      remove_backup
    end

    def remove_backup
      FileUtils.rm(file_backup)
    end

    def self.parse(file)
      Bundler::Definition.build(file, nil, nil).dependencies.map do |gem|
        name = gem.name
        version_range, version = gem.requirements_list.first.split(' ')

        Gem.new(name: name,
                current_version: version,
                version_range: version_range)
      end
    end

    def update
      backup

      File.open(file_backup) do |current|
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

      show_version_diff
      remove_backup
    rescue StandardError => e
      restore
      puts e.message
    end

    def show_version_diff
      @gems.each do |gem|
        if gem.update_available
          puts "#{gem.name} \"#{gem.version_range} #{gem.current_version}\" -> \"#{gem.version_range} #{gem.latest_version}\""
        end
      end
    end
  end
end
