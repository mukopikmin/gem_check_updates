require 'spec_helper'

RSpec.describe GemCheckUpdates::Gem do
  describe '#check_update!' do
    context 'with success version check' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'example', current_version: '0.1', version_range: '~>') }
      let(:version) {'1.0'}
      let(:response) { { version: version }.to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }
      before(:each) {gem.check_update!}

      it 'sets latest_version and update_available' do
        expect(gem.latest_version).to eq(version)
        expect(gem.update_available).to be_truthy
      end
    end

    context 'with failed version check' do
      let(:gem) { GemCheckUpdates::Gem.new(name: 'example', current_version: '0.1', version_range: '~>') }
      let(:response) {
        {
          status: 404,
          error: "Not Found"
        }.to_json
      }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(status: 404, body: response) }
      before(:each) {gem.check_update!}

      it 'sets failed values to latest_version and update_available' do
        expect(gem.latest_version).to be_nil
        expect(gem.update_available).to be_falsey
      end
    end
  end
end
