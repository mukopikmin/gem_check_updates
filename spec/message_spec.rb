# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Message do
  let(:file) { 'spec/fixtures/Gemfile-ok' }
  let(:gemfile) { GemCheckUpdates::Gemfile.new(file) }
  let(:response) { { version: '1.0' }.to_json }

  describe '.updatable_gems' do
    let(:message) { GemCheckUpdates::Message.updatable_gems(gemfile) }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

    it 'returns message about updatable gems' do
      expect(message).to be_a(String)
    end
  end

  describe '.update_completed' do
    let(:message) { GemCheckUpdates::Message.update_completed(gemfile) }

    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

    it 'returns message about updatable gems' do
      expect(message).to be_a(String)
    end
  end
end
