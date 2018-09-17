# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Runner do
  describe '.run' do
    let(:file) { 'spec/fixtures/gemfile/success' }
    let(:argv) { ['-f', file] }
    let(:before_update) { File.read(file) }
    let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { GemCheckUpdates::Runner.run(argv) }

    it 'does not change existing Gemfile' do
      expect(File.read(file)).to eq(before_update)
    end
  end
end
