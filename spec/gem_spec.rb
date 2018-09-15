# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Gem do
  describe '#update_available?' do
    context 'with available updates' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'test', current_version: '0.0.1') }
      let(:response) { JSON.load(File.open('spec/fixtures/rubygems.org/versions.json')).to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'returns true' do
        expect(gem.update_available?).to be_truthy
      end
    end

    context 'with invalid gem' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'test', current_version: '0.0.1') }
      let(:response) { [].to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'returns true' do
        expect(gem.update_available?).to be_falsey
      end
    end

    context 'with gem without version specification' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'test') }
      let(:response) { JSON.load(File.open('spec/fixtures/rubygems.org/versions.json')).to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'returns true' do
        expect(gem.update_available?).to be_falsey
      end
    end

    context 'with no update' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'test', current_version: '1.0.0') }
      let(:response) { JSON.load(File.open('spec/fixtures/rubygems.org/versions.json')).to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'returns true' do
        expect(gem.update_available?).to be_falsey
      end
    end
  end

  describe '#check_update!' do
    context 'with success version check' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'example', current_version: '0.0.1', version_range: '~>') }
      let(:version) { '1.0.0' }
      let(:response) { JSON.load(File.open('spec/fixtures/rubygems.org/versions.json')).to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
      before(:each) { gem.check_update!(GemCheckUpdates::VersionScope::MAJOR) }

      it 'sets latest_version' do
        expect(gem.latest_version).to eq(version)
      end
    end

    context 'with failed version check' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'example', current_version: '0.0.1', version_range: '~>') }
      let(:response) do
        {
          status: 404,
          error: 'Not Found'
        }.to_json
      end

      before(:each) { stub_request(:get, /rubygems.org/).to_return(status: 404, body: response) }
      before(:each) { gem.check_update!(GemCheckUpdates::VersionScope::MAJOR) }

      it 'sets failed values to latest_version' do
        expect(gem.latest_version).to be_nil
      end
    end
  end

  describe '#scoped_latest_version' do
    context 'on major update' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'example', current_version: '0.0.1', version_range: '~>') }
      let(:versions) { JSON.load(File.open('spec/fixtures/rubygems.org/versions.json')) }
      let(:scope) { GemCheckUpdates::VersionScope::MAJOR }
      let(:latest_version) { gem.scoped_latest_version(versions, scope) }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: versions.to_json) }

      it 'updates major version' do
        expect(latest_version).to eq('1.0.0')
      end
    end

    context 'on minor update' do
    end

    context 'on patch update' do
    end
  end
end
