# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Runner do
  describe '.parse_options' do
    context 'single option' do
      let(:argv) { ['-f', 'Gemfile'] }
      let(:expected) do
        {
          file: 'Gemfile',
          apply: false
        }
      end
      let(:options) { GemCheckUpdates::Runner.parse_options(argv) }

      it 'returns parsed options' do
        expect(options).to be_a(Hash)
      end
    end
  end

  describe '.update_scope' do
    context 'on major update' do
      let(:options) do
        {
          major: true,
          minor: true,
          patch: true
        }
      end
      let(:scope) { GemCheckUpdates::Runner.update_scope(options) }

      it 'returns major update scope' do
        expect(scope).to eq(GemCheckUpdates::VersionScope::MAJOR)
      end
    end

    context 'on minor update' do
      let(:options) do
        {
          major: false,
          minor: true,
          patch: true
        }
      end
      let(:scope) { GemCheckUpdates::Runner.update_scope(options) }

      it 'returns major update scope' do
        expect(scope).to eq(GemCheckUpdates::VersionScope::MINOR)
      end
    end

    context 'on patch update' do
      let(:options) do
        {
          major: false,
          minor: false,
          patch: true
        }
      end
      let(:scope) { GemCheckUpdates::Runner.update_scope(options) }

      it 'returns major update scope' do
        expect(scope).to eq(GemCheckUpdates::VersionScope::PATCH)
      end
    end
  end
end
