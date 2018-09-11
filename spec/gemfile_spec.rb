require 'spec_helper'

RSpec.describe GemCheckUpdates::Gemfile do
  describe '#parse' do
    context 'with parsable Gemfile' do
      let(:file) { 'spec/fixtures/Gemfile-ok' }
      let(:gemfile) { GemCheckUpdates::Gemfile.new(file) }
      let(:response) { { version: '1.0' }.to_json }

      before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

      it 'returns parsed gems' do
        expect(gemfile.gems).to be_a(Array)
      end
    end

    context 'with unparsable Gemfile' do
      let(:file) { 'spec/fixtures/Gemfile-fail' }

      it 'returns parsed gems' do
        expect { GemCheckUpdates::Gemfile.new(file) }.to raise_error(Bundler::Dsl::DSLError)
      end
    end
  end
end
