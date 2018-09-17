# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Runner do
  # describe '.parse_options' do
  #   context 'single option' do
  #     let(:argv) { ['-f', 'Gemfile', '--major', '--minor', '--patch'] }
  #     let(:options) { GemCheckUpdates::Runner.parse_options(argv) }

  #     it 'returns parsed options' do
  #       expect(options).to be_a(Hash)
  #     end
  #   end
  # end

  # describe '.update_scope' do
  #   context 'on major update' do
  #     let(:options) do
  #       [{
  #         major: true,
  #         minor: true,
  #         patch: true
  #       }, {
  #         major: true,
  #         minor: false,
  #         patch: false
  #       }, {
  #         major: true,
  #         minor: false,
  #         patch: true
  #       }, {
  #         major: true,
  #         minor: true,
  #         patch: false
  #       }, {
  #         major: false,
  #         minor: false,
  #         patch: false
  #       }]
  #     end
  #     let(:scopes) { options.map { |o| GemCheckUpdates::Runner.update_scope(o) } }

  #     it 'returns major update scope' do
  #       expect(scopes).to all(eq(GemCheckUpdates::VersionScope::MAJOR))
  #     end
  #   end

  #   context 'on minor update' do
  #     let(:options) do
  #       [{
  #         major: false,
  #         minor: true,
  #         patch: true
  #       }, {
  #         major: false,
  #         minor: true,
  #         patch: false
  #       }]
  #     end
  #     let(:scopes) { options.map { |o| GemCheckUpdates::Runner.update_scope(o) } }

  #     it 'returns major update scope' do
  #       expect(scopes).to all(eq(GemCheckUpdates::VersionScope::MINOR))
  #     end
  #   end

  #   context 'on patch update' do
  #     let(:options) do
  #       {
  #         major: false,
  #         minor: false,
  #         patch: true
  #       }
  #     end
  #     let(:scope) { GemCheckUpdates::Runner.update_scope(options) }

  #     it 'returns major update scope' do
  #       expect(scope).to eq(GemCheckUpdates::VersionScope::PATCH)
  #     end
  #   end
  # end
end
