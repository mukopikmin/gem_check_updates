require './lib/gem_check_updates'

gemfile = GemCheckUpdates::Gemfile.new('spec/fixtures/samples/Gemfile')

pp gemfile.show_version_diff