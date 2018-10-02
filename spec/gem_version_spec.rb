# frozen_string_literal: true

require 'spec_helper'

RSpec.describe GemCheckUpdates::GemVersion do
  describe '#version_specified?' do
    context 'with version its number is specified' do
      subject do
        GemCheckUpdates::GemVersion.new(number: '0.0.1')
                                   .version_specified?
      end

      it { is_expected.to be true }
    end

    context 'with version its number is not specified' do
      subject { GemCheckUpdates::GemVersion.new.version_specified? }

      it { is_expected.to be false }
    end
  end

  describe '#<=>' do
    let(:version1) { GemCheckUpdates::GemVersion.new(number: '0.0.1') }
    let(:version2) { GemCheckUpdates::GemVersion.new(number: '0.0.2') }

    it 'returns version2 as a later version' do
      expect(version1).to be < version2
    end
  end

  describe '#to_s' do
    let(:number) { '0.0.1' }
    let(:version) { GemCheckUpdates::GemVersion.new(number: number) }

    it 'returns number itself' do
      expect(version.to_s).to eq(number)
    end
  end
end
