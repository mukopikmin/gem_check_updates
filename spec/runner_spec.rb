require 'spec_helper'

RSpec.describe GemCheckUpdates::Runner do
  describe '.parse_options' do
    context 'single option' do
      let(:argv) { ['-f','Gemfile'] }
      let(:expected) {
        {
          file: 'Gemfile',
          apply: false
        }
      }
      subject(:options) { GemCheckUpdates::Runner.parse_options(argv) }

      it 'returns parsed options' do
        is_expected.to eq(expected)
      end
    end
  end
end
