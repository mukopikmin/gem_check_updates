# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Gemfile do
  describe '#backup' do
    let(:file) { 'spec/fixtures/Gemfile-ok' }
    let(:gemfile) { GemCheckUpdates::Gemfile.new(file) }
    let(:response) { { version: '1.0' }.to_json }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { gemfile.backup }
    after(:each) { gemfile.remove_backup }

    it 'creates backup file' do
      expect(File).to exist("#{file}.backup")
    end
  end

  describe '#restore' do
    let(:file) { 'spec/fixtures/Gemfile-ok' }
    let(:gemfile) { GemCheckUpdates::Gemfile.new(file) }
    let(:response) { { version: '1.0' }.to_json }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { gemfile.backup }
    before(:each) { gemfile.restore }

    it 'restore from backup file' do
      expect(File).not_to exist("#{file}.backup")
    end
  end

  describe '#remove_backup' do
    let(:file) { 'spec/fixtures/Gemfile-ok' }
    let(:gemfile) { GemCheckUpdates::Gemfile.new(file) }
    let(:response) { { version: '1.0' }.to_json }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { gemfile.backup }
    before(:each) { gemfile.remove_backup }

    it 'restore from backup file' do
      expect(File).not_to exist("#{file}.backup")
    end
  end

  describe '#parse' do
    context 'with parsable Gemfile' do
      let(:file) { 'spec/fixtures/Gemfile-ok' }
      let(:gemfile) { GemCheckUpdates::Gemfile.new(file) }
      let(:response) { { version: '1.0' }.to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'returns parsed gems' do
        expect(gemfile.gems).to be_a(Array)
        expect(gemfile.gems).to all(be_a(GemCheckUpdates::Gem))
      end
    end

    context 'with unparsable Gemfile' do
      let(:file) { 'spec/fixtures/Gemfile-fail' }

      it 'returns parsed gems' do
        expect { GemCheckUpdates::Gemfile.new(file) }.to raise_error(Bundler::Dsl::DSLError)
      end
    end
  end

  describe '#update' do
    let(:file) { 'spec/fixtures/Gemfile-ok' }
    let(:gemfile) { GemCheckUpdates::Gemfile.new(file) }
    let(:response) { { version: '1.0' }.to_json }
    let(:updated_gemfile) { GemCheckUpdates::Gemfile.new(file) }
    let(:updatable_gems) { updated_gemfile.gems.select(&:update_available?) }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { gemfile.backup }
    before(:each) { gemfile.update }
    after(:each) { gemfile.restore }

    it 'overwrite Gemfile with newer version' do
      expect(updatable_gems.map(&:current_version)).to all(be >= '1.0')
    end
  end
end
