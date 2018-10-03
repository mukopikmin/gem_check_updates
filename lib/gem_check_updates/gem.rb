# frozen_string_literal: true

module GemCheckUpdates
  class Gem
    DEFAULT_SCOPE = GemCheckUpdates::VersionScope::MAJOR

    attr_accessor :name
    attr_accessor :current_version
    attr_accessor :versions
    attr_accessor :version_range

    def initialize(name: nil,
                   current_version: nil,
                   versions: [],
                   version_range: nil,
                   update_scope: DEFAULT_SCOPE)
      @name = name
      @current_version = current_version
      @versions = versions
      @version_range = version_range
      @update_scope = update_scope
    end

    def update_available?
      !latest_version.nil? &&
        !@current_version.nil? &&
        @current_version.version_specified? &&
        latest_version > @current_version
    end

    def latest_version
      # Ignore pre release version (ex. beta, rc), and sort desc
      versions = @versions.reject(&:pre_release)
                          .sort_by { |v| [v.major, v.minor, v.patch] }
                          .reverse

      case @update_scope
      when GemCheckUpdates::VersionScope::MINOR
        versions.select { |v| v.major == @current_version.major }.first
      when GemCheckUpdates::VersionScope::PATCH
        versions.select do |v|
          v.major == @current_version.major && v.minor == @current_version.minor
        end.first
      else
        # This branch is equal to specifying major updates
        versions.first
      end
    end

    def highlighted_latest_version
      major = @current_version.major == latest_version.major ? latest_version.major : latest_version.major.green
      minor = @current_version.minor == latest_version.minor ? latest_version.minor : latest_version.minor.green
      patch = @current_version.patch == latest_version.patch ? latest_version.patch : latest_version.patch.green

      [major, minor, patch].join('.')
    end
  end
end
