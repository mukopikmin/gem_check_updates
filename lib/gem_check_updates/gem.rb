module GemCheckUpdates

  RUBYGEMS_API = 'https://rubygems.org/api/v1/versions'

  class Gem
    attr_reader :name, :latest_version, :current_version, :update_available, :version_range

    def initialize(name: nil, current_version: nil, version_range: nil)
      @name = name
      @current_version = current_version
      @version_range = version_range

      @update_available, @latest_version = self.class.check_update(name, current_version)
    end

    def self.check_update(name, current_version)
      response = RestClient.get("#{RUBYGEMS_API}/#{name}/latest.json")
      version = JSON.parse(response.body)['version']

      update_available = version > current_version
      latest_version = version

      [update_available, latest_version]
    rescue
      [false, nil]
    end

    def update_exists?
      @update_available && @current_version != '0'
    end
  end
end
