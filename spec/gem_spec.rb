# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Gem do
  describe '#update_available?' do
    context 'with available updates' do
      let(:gem) do
        described_class.new(name: 'test',
                            current_version: '0.0.1',
                            latest_version: '0.0.2')
      end

      it 'returns true' do
        expect(gem.update_available?).to be_truthy
      end
    end

    context 'with invalid gem' do
      let(:gem) do
        described_class.new(name: 'test',
                            current_version: '0.0.1',
                            latest_version: nil)
      end

      it 'returns true' do
        expect(gem.update_available?).to be_falsey
      end
    end

    context 'with gem without version specification' do
      let(:gem) { described_class.new(name: 'test') }

      it 'returns true' do
        expect(gem.update_available?).to be_falsey
      end
    end

    context 'with no update' do
      let(:gem) do
        described_class.new(name: 'test',
                            current_version: '1.0.0',
                            latest_version: '1.0.0')
      end

      it 'returns true' do
        expect(gem.update_available?).to be_falsey
      end
    end
  end

  describe '#scoped_latest_version' do
    let(:versions) { JSON.parse(File.read('spec/fixtures/rubygems.org/versions.json')) }

    context 'on major update' do
      let(:gem) do
        described_class.new(name: 'example',
                            current_version: '0.0.1',
                            update_scope: GemCheckUpdates::VersionScope::MAJOR,
                            version_range: '~>')
      end
      let(:latest_version) { gem.scoped_latest_version(versions) }

      it 'updates major version' do
        expect(latest_version).to eq('1.0.0')
      end
    end

    context 'on minor update' do
      let(:gem) do
        described_class.new(name: 'example',
                            current_version: '0.0.1',
                            update_scope: GemCheckUpdates::VersionScope::MINOR,
                            version_range: '~>')
      end
      let(:latest_version) { gem.scoped_latest_version(versions) }

      it 'updates major version' do
        expect(latest_version).to eq('0.10.0')
      end
    end

    context 'on patch update' do
      let(:gem) do
        described_class.new(name: 'example',
                            current_version: '0.0.1',
                            update_scope: GemCheckUpdates::VersionScope::PATCH,
                            version_range: '~>')
      end
      let(:latest_version) { gem.scoped_latest_version(versions) }

      it 'updates major version' do
        expect(latest_version).to eq('0.0.2')
      end
    end
  end
end
