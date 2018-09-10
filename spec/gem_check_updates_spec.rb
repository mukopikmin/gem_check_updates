require 'spec_helper'

RSpec.describe GemCheckUpdates do
  it 'has a version number' do
    expect(GemCheckUpdates::VERSION).not_to be nil
  end
end
