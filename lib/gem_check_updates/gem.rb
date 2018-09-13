# frozen_string_literal: true

module GemCheckUpdates
  RUBYGEMS_API = 'https://rubygems.org/api/v1/versions'

  class Gem
    attr_reader :name,
                :latest_version,
                :current_version,
                :version_range

    def initialize(name: nil, current_version: nil, version_range: nil)
      @name = name
      @current_version = current_version
      @version_range = version_range

      check_update!
    end

    def update_available?
      !@latest_version.nil? && @current_version != '0' && @latest_version > @current_version
    end

    def check_update!
      response = RestClient.get("#{RUBYGEMS_API}/#{name}/latest.json")
      version = JSON.parse(response.body)['version']

      @latest_version = version

      self
    rescue StandardError
      @latest_version = nil

      puts "Failed to check version \"#{@name}\".".red
    end
  end
end
