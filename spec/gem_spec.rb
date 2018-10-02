# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::Gem do
  describe '#update_available?' do
    let(:versions) do
      [
        GemCheckUpdates::GemVersion.new(number: '0.0.1'),
        GemCheckUpdates::GemVersion.new(number: '0.0.2')
      ]
    end

    context 'with available updates' do
      subject do
        described_class.new(name: 'test',
                            current_version: versions.first,
                            versions: versions)
                       .update_available?
      end

      it { is_expected.to be_truthy }
    end

    context 'with invalid gem' do
      subject do
        described_class.new(name: 'test',
                            current_version: versions.first)
                       .update_available?
      end

      it { is_expected.to be_falsey }
    end

    context 'with gem without version specification' do
      subject { described_class.new(name: 'test').update_available? }

      it { is_expected.to be_falsey }
    end

    context 'with no update' do
      subject do
        described_class.new(name: 'test',
                            current_version: versions.first,
                            versions: [versions.first])
                       .update_available?
      end

      it { is_expected.to be_falsey }
    end
  end

  describe '#latest_version' do
    let(:versions) do
      [
        GemCheckUpdates::GemVersion.new(number: '0.0.1'),
        GemCheckUpdates::GemVersion.new(number: '0.0.2'),
        GemCheckUpdates::GemVersion.new(number: '0.10.0'),
        GemCheckUpdates::GemVersion.new(number: '1.0.0')
      ]
    end

    context 'on major update' do
      let(:gem) do
        described_class.new(name: 'example',
                            current_version: versions.first,
                            update_scope: GemCheckUpdates::VersionScope::MAJOR,
                            version_range: '~>',
                            versions: versions)
      end

      it 'updates major version' do
        expect(gem.latest_version.number).to eq('1.0.0')
      end
    end

    context 'on minor update' do
      let(:gem) do
        described_class.new(name: 'example',
                            current_version: versions.first,
                            update_scope: GemCheckUpdates::VersionScope::MINOR,
                            version_range: '~>',
                            versions: versions)
      end

      it 'updates major version' do
        expect(gem.latest_version.number).to eq('0.10.0')
      end
    end

    context 'on patch update' do
      let(:gem) do
        described_class.new(name: 'example',
                            current_version: versions.first,
                            update_scope: GemCheckUpdates::VersionScope::PATCH,
                            version_range: '~>',
                            versions: versions)
      end

      it 'updates major version' do
        expect(gem.latest_version.number).to eq('0.0.2')
      end
    end
  end
end
