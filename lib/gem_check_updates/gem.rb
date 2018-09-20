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

    def check_update!(update_scope, include_beta = false)
      response = RestClient.get("#{RUBYGEMS_API}/#{name}.json")
      versions = JSON.parse(response.body)

      @latest_version = scoped_latest_version(versions, update_scope, include_beta)

      self
    rescue StandardError => e
      @latest_version = nil

      GemCheckUpdates::Message.out("Failed to check version \"#{@name}\".".red)
      GemCheckUpdates::Message.out("\n\n")
      GemCheckUpdates::Message.out(e.message.red)
    end

    def scoped_latest_version(versions, scope, include_beta)
      numbers = versions.map { |v| v['number'] }
                        .map { |v| include_beta ? v : self.class.ignore_beta(v) }
      current_major, current_minor = @current_version.split('.')

      case scope
      when GemCheckUpdates::VersionScope::MINOR
        numbers.select { |n| n.split('.').first == current_major }.max
      when GemCheckUpdates::VersionScope::PATCH
        numbers.select do |n|
          major, minor = n.split('.')
          major == current_major && minor == current_minor
        end.max
      else
        # This branch is equal to specifying major updates
        numbers.max
      end
    end

    def self.ignore_beta(version)
      parts = version.split('.')
      parts.pop if /^.+\..+\..+\..+$/.match?(version)

      parts.join('.')
    end
  end
end
