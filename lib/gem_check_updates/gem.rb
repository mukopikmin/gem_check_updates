module GemCheckUpdates
  RUBYGEMS_API = 'https://rubygems.org/api/v1/versions'.freeze

  class Gem
    attr_reader :name,
                :latest_version,
                :current_version,
                :update_available,
                :version_range

    def initialize(name: nil, current_version: nil, version_range: nil)
      @name = name
      @current_version = current_version
      @version_range = version_range

      check_update!
    end

    def check_update!
      response = RestClient.get("#{RUBYGEMS_API}/#{name}/latest.json")
      version = JSON.parse(response.body)['version']

      @update_available = version > current_version
      @latest_version = version
    rescue StandardError
      @update_available = false
      @latest_version = nil
    end
  end
end
