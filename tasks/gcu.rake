# frozen_string_literal: true

require 'gem_check_updates'

desc 'Check new versions of rubygems'
task :gcu do
  GemCheckUpdates::Runner.run([])
end

namespace :gcu do
  desc 'Check major updates of rubygems'
  task :major do
    GemCheckUpdates::Runner.run(['--major'])
  end

  namespace :major do
    desc 'Check major updates of rubygems, and apply to Gemfile'
    task :apply do
      argv = [
        '--major',
        '--apply'
      ]
      GemCheckUpdates::Runner.run(argv)
    end
  end

  desc 'Check minor updates of rubygems'
  task :minor do
    GemCheckUpdates::Runner.run(['--minor'])
  end

  namespace :minor do
    desc 'Check minor updates of rubygems, and apply to Gemfile'
    task :apply do
      argv = [
        '--minor',
        '--apply'
      ]
      GemCheckUpdates::Runner.run(argv)
    end
  end

  desc 'Check patch updates of rubygems'
  task :patch do
    GemCheckUpdates::Runner.run(['--patch'])
  end

  namespace :patch do
    desc 'Check patch updates of rubygems, and apply to Gemfile'
    task :apply do
      argv = [
        '--patch',
        '--apply'
      ]
      GemCheckUpdates::Runner.run(argv)
    end
  end
end

desc 'Check major updates of rubygems, and apply to Gemfile'
task 'gcu:apply': 'gcu:major:apply'
