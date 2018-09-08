module GemCheckUpdates
  class Client
  include Virtus.model

  attribute :gemfile, String
  attribute :gems, Array[Gem]
  attribute :gemfile_parsed, Boolean
  attribute :version_checked, Boolean

  def gemfile_backup
    "#{self.gemfile}.backup"
  end

  def backup
    FileUtils.cp(self.gemfile, self.gemfile_backup)
  end

  def remove_backup
    FileUtils.rm(self.gemfile_backup)
  end

  def parse
    gems = Bundler::Definition.build(gemfile, nil, nil).dependencies

    self.gems = gems.map do |gem|
      name = gem.name
      version_range, version = gem.requirements_list.first.split(' ')
      checker = GemUpdateChecker::Client.new(name, version)

      Gem.new(name: name,
              latest_version: checker.latest_version,
              current_version: version,
              update_available: checker.update_available,
              version_range: version_range)
    end
  end

  def update
    begin
      backup

      File.open(self.gemfile_backup) do |current|
        File.open(self.gemfile, 'w') do |updated|
          current.each_line do |line|
            if matcher = line.match(/gem ['"](.+?)['"]\s*,\s*['"][>=|~>]*\s+(.+?)['"]/)
              _, name, old_version = *matcher
              target = gems.find { |gem| gem.name == name }

              unless target.nil?
                line.gsub!(old_version, target.latest_version)
              end
            end

            updated.puts(line)
          end
        end
      end

      show_version_diff
      remove_backup
    rescue
      puts "Updating #{gemfile} failed. To rescue original #{gemfile}, see #{gemfile_backup}"
    end
  end

  def dry_run
    show_version_diff
  end

  def show_version_diff
    gems.each do |gem|
      if gem.update_exists?
        puts "#{gem.name} \"#{gem.version_range} #{gem.current_version}\" -> \"#{gem.version_range} #{gem.latest_version}\""
      end
    end
  end
end
end