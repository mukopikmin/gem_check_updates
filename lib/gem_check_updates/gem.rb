module GemCheckUpdates
  class Gem
    attr_accessor :name, :latest_version, :current_version, :update_available, :version_range

    def initialize(name: nil, latest_version: nil, current_version: nil, update_available: false, version_range: nil)
      @name = name
      @latest_version = latest_version
      @current_version = current_version
      @update_available = update_available
      @version_range = version_range
    end

    def update_exists?
      @update_available && @current_version != '0'
    end
  end
end
