# frozen_string_literal: true

module GemCheckUpdates
  class RakeTask < Rake::TaskLib
    attr_accessor :name
    attr_accessor :argv

    def initialize
      @name = :gcu
      @argv = []

      define
    end

    def define
      desc 'Check major updates of rubygems, and apply to Gemfile'
      task(name) { run_task }
    end

    def run_task
      GemCheckUpdates::Runner.run(argv)
    end
  end
end
