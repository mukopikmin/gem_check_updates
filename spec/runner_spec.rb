# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Runner do
  describe '.run' do
    context 'with valid Germfile' do
      let(:file) { 'spec/fixtures/gemfile/success' }
      let(:argv) { ['-f', file] }
      let(:before_update) { File.read(file) }
      let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
      before(:each) { GemCheckUpdates::Runner.run(argv) }

      it 'check updates, though does not overwrite Gemfile' do
        expect(File.read(file)).to eq(before_update)
      end
    end

    context 'with unexisting Gemfile' do
      let(:file) { 'path/to/unexisting/gemfile' }
      let(:argv) { ['-f', file] }

      it 'exit with error' do
        expect { GemCheckUpdates::Runner.run(argv) }.to raise_error(SystemExit)
      end
    end

    context 'with unconnected network' do
      let(:file) { 'spec/fixtures/gemfile/success' }
      let(:argv) { ['-f', file] }
      let(:before_update) { File.read(file) }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(status: 500, body: nil) }

      it 'check updates, though does not overwrite Gemfile' do
        expect { GemCheckUpdates::Runner.run(argv) }.to raise_error(SystemExit)
      end
    end
  end
end
