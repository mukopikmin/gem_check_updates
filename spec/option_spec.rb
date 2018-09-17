# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Option do
  describe '.parse' do
    context 'single option' do
      let(:argv) { ['-f', 'Gemfile', '--major', '--minor', '--patch'] }
      let(:options) { GemCheckUpdates::Option.parse(argv) }

      it 'returns parsed options' do
        expect(options).to be_a(GemCheckUpdates::Option)
      end
    end
  end

  describe '#update_scope' do
    context 'on major update' do
      let(:options) do
        [
          ['--major'],
          ['']
        ]
      end
      let(:scopes) do
        options.map { |option| GemCheckUpdates::Option.parse(option) }
               .map(&:update_scope)
      end

      it 'returns major update scope' do
        expect(scopes).to all(eq(GemCheckUpdates::VersionScope::MAJOR))
      end
    end

    context 'on minor update' do
      let(:options) do
        [
          ['--major', '--minor'],
          ['--minor']
        ]
      end
      let(:scopes) do
        options.map { |option| GemCheckUpdates::Option.parse(option) }
               .map(&:update_scope)
      end

      it 'returns minor update scope' do
        expect(scopes).to all(eq(GemCheckUpdates::VersionScope::MINOR))
      end
    end

    context 'on patch update' do
      let(:options) do
        [
          ['--major', '--minor', '--patch'],
          ['--minor', '--patch'],
          ['--patch']
        ]
      end
      let(:scopes) do
        options.map { |option| GemCheckUpdates::Option.parse(option) }
               .map(&:update_scope)
      end

      it 'returns patch update scope' do
        expect(scopes).to all(eq(GemCheckUpdates::VersionScope::PATCH))
      end
    end
  end
end
