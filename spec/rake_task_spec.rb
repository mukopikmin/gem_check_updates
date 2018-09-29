require 'spec_helper'
require 'gem_check_updates/rake_task'

RSpec.describe GemCheckUpdates::RakeTask do
  describe 'defining tasks' do
    it 'creates a gcu task' do
      described_class.new

      expect(Rake::Task.task_defined?(:gcu)).to be true
    end
  end
end
