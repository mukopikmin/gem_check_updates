module GemCheckUpdates
  class Gem
  include Virtus.model

  attribute :name, String
  attribute :latest_version, String
  attribute :current_version, String
  attribute :update_available, Boolean
  attribute :version_range, String

  def update_exists?
    self.update_available && current_version != '0'
  end
end
end