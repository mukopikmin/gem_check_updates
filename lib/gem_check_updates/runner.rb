module GemCheckUpdates
  class Runner 
    def self.run
      gemfile = Gemfile.new('spec/fixtures/samples/Gemfile')
      gemfile.update
    end
  end
end
