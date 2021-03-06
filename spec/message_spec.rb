# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Message do
  let(:file) { 'spec/fixtures/gemfile/success' }
  let(:option) { GemCheckUpdates::Option.new(file: file) }
  let(:gemfile) { GemCheckUpdates::Gemfile.new(option) }
  let(:response) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')).to_json }

  describe '.out' do
    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

    it 'output given message' do
      expect { GemCheckUpdates::Message.out('This is test') }.not_to raise_error
    end
  end

  describe '.updatable_gems' do
    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

    it 'output message about updatable gems' do
      expect { GemCheckUpdates::Message.updatable_gems(gemfile) }.not_to raise_error
    end
  end

  describe '.update_completed' do
    before(:each) { stub_request(:get, /rubygems.org/).to_return(body: response) }

    it 'output message about updatable gems' do
      expect { GemCheckUpdates::Message.update_completed(gemfile) }.not_to raise_error
    end
  end
end
