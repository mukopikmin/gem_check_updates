# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Gem do
  describe '#update_available?' do
    context 'with available update' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'test', current_version: '0.1') }
      let(:response) { { version: '1.0' }.to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'retrurns true' do
        expect(gem.update_available?).to be_truthy
      end
    end

    context 'with invalid gem' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'test', current_version: '0.1') }
      let(:response) { { version: nil }.to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'retrurns true' do
        expect(gem.update_available?).to be_falsey
      end
    end

    context 'with gem without version specification' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'test') }
      let(:response) { { version: nil }.to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'retrurns true' do
        expect(gem.update_available?).to be_falsey
      end
    end

    context 'with no update' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'test', current_version: '0.1') }
      let(:response) { { version: '0.1' }.to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'retrurns true' do
        expect(gem.update_available?).to be_falsey
      end
    end
  end

  describe '#check_update!' do
    context 'with success version check' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'example', current_version: '0.1', version_range: '~>') }
      let(:version) { '1.0' }
      let(:response) { { version: version }.to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
      before(:each) { gem.check_update! }

      it 'sets latest_version' do
        expect(gem.latest_version).to eq(version)
      end
    end

    context 'with failed version check' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'example', current_version: '0.1', version_range: '~>') }
      let(:response) do
        {
          status: 404,
          error: 'Not Found'
        }.to_json
      end

      before(:each) { stub_request(:get, /rubygems.org/).to_return(status: 404, body: response) }
      before(:each) { gem.check_update! }

      it 'sets failed values to latest_version' do
        expect(gem.latest_version).to be_nil
      end
    end
  end
end
