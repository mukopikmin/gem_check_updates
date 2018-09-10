require 'spec_helper'

RSpec.describe GemCheckUpdates::Gemfile do
  describe '.parse' do


    context 'with parsable Gemfile' do
      let(:file) {'spec/fixtures/Gemfile-ok'}
      let(:gems) {GemCheckUpdates::Gemfile.parse(file)}

      it 'returns parsed gems' do
        expect(gems).to be_a(Array)
      end
    end

    context 'with unparsable Gemfile' do

    end
  end
end
