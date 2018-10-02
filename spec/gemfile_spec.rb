# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Gemfile do
  describe '#backup' do
    let(:file) { 'spec/fixtures/gemfile/success' }
    let(:option) { GemCheckUpdates::Option.new(file: file) }
    let(:gemfile) { described_class.new(option) }
    let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { gemfile.backup }
    after(:each) { gemfile.remove_backup }

    it 'creates backup file' do
      expect(File).to exist("#{file}.backup")
    end
  end

  describe '#restore' do
    let(:file) { 'spec/fixtures/gemfile/success' }
    let(:option) { GemCheckUpdates::Option.new(file: file) }
    let(:gemfile) { described_class.new(option) }
    let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { gemfile.backup }
    before(:each) { gemfile.restore }

    it 'restore from backup file' do
      expect(File).not_to exist("#{file}.backup")
    end
  end

  describe '#remove_backup' do
    let(:file) { 'spec/fixtures/gemfile/success' }
    let(:option) { GemCheckUpdates::Option.new(file: file) }
    let(:gemfile) { described_class.new(option) }
    let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { gemfile.backup }
    before(:each) { gemfile.remove_backup }

    it 'restore from backup file' do
      expect(File).not_to exist("#{file}.backup")
    end
  end

  describe '#parse' do
    context 'with parsable Gemfile' do
      let(:file) { 'spec/fixtures/gemfile/success' }
      let(:option) { GemCheckUpdates::Option.new(file: file) }
      let(:gemfile) { described_class.new(option) }
      let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'returns parsed gems' do
        expect(gemfile.gems).to be_a(Array)
        expect(gemfile.gems).to all(be_a(GemCheckUpdates::Gem))
      end
    end

    context 'with unparsable Gemfile' do
      let(:file) { 'spec/fixtures/gemfile/fail' }
      let(:option) { GemCheckUpdates::Option.new(file: file) }

      it 'returns parsed gems' do
        expect { described_class.new(option) }.to raise_error(Bundler::Dsl::DSLError)
      end
    end
  end

  describe '#check_update!' do
    let(:file) { 'spec/fixtures/gemfile/success' }
    let(:option) { GemCheckUpdates::Option.new(file: file) }
    let(:gemfile) { described_class.new(option) }
    let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }

    before { stub_request(:get, /rubygems.org/).to_return(body: response) }

    it 'fills latest_version in gem' do
      expect(gemfile.check_updates!.map(&:latest_version)).to all(be_a(GemCheckUpdates::GemVersion))
    end
  end

  describe '#update' do
    let(:file) { 'spec/fixtures/gemfile/success' }
    let(:option) { GemCheckUpdates::Option.new(file: file) }
    let(:gemfile) { described_class.new(option) }
    let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }
    let(:updatable_gems) { described_class.new(option).gems.select(&:update_available?) }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
    before(:each) { gemfile.backup }
    before(:each) { gemfile.update }
    after(:each) { gemfile.restore }

    it 'overwrite Gemfile with newer version' do
      expect(updatable_gems.map(&:current_version).map(&:number)).to all(be >= '1.0')
    end
  end
end
