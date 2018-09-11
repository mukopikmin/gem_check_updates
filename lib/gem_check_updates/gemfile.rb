module GemCheckUpdates
  class Gemfile
    attr_reader :gems

    def initialize(file)
      @file = file
      @gems = parse
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

    def parse
      gems = Bundler::Definition.build(@file, nil, nil).dependencies.map do |gem|
        print '.'

        name = gem.name
        version_range, version = gem.requirements_list.first.split(' ')

        Gem.new(name: name,
                current_version: version,
                version_range: version_range)
      end

      puts
      puts

      gems
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
      puts e.message.red
    end

    def show_version_diff
      puts 'Following gems can be updated.'
      puts 'If you want to apply these updates, run command with option \'-a\'.'
      puts ' (Caution: This option will overwrite your Gemfile)'.red
      puts

      @gems.each do |gem|
        if gem.update_available?
          puts "    #{gem.name} \"#{gem.version_range} #{gem.current_version}\" → \"#{gem.version_range} #{gem.latest_version.green}\""
        end
      end

      puts
      puts
    end
  end
end
