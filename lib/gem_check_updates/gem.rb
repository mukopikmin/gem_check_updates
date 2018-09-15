# frozen_string_literal: true

module GemCheckUpdates
  RUBYGEMS_API = 'https://rubygems.org/api/v1/versions'

  class Gem
    attr_reader :name,
                :latest_version,
                :current_version,
                :version_range

    def initialize(name: nil,
                   current_version: nil,
                   version_range: nil,
                   update_scope: GemCheckUpdates::VersionScope::MAJOR)
      @name = name
      @current_version = current_version
      @version_range = version_range

      check_update!(update_scope)
    end

    def update_available?
      !@latest_version.nil? &&
        !@current_version.nil? &&
        @current_version != '0' &&
        @latest_version > @current_version
    end

    def check_update!(update_scope)
      response = RestClient.get("#{RUBYGEMS_API}/#{name}.json")
      versions = JSON.parse(response.body)

      @latest_version = scoped_latest_version(versions, update_scope)

      self
    rescue StandardError => e
      @latest_version = nil

      puts "Failed to check version \"#{@name}\".".red
    end

    def scoped_latest_version(versions, scope)
      numbers = versions.map { |v| v['number'] }

      case scope
      when GemCheckUpdates::VersionScope::MAJOR
        numbers.max
      when GemCheckUpdates::VersionScope::MINOR, GemCheckUpdates::VersionScope::PATCH
        current = @current_version.split('.')[scope - 1]
        numbers.select { |n| n.split('.')[scope - 1] == current }.max
      else
        numbers.max
      end
    end
  end
end
