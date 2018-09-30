# frozen_string_literal: true

module GemCheckUpdates
  class Gem
    DEFAULT_SCOPE = GemCheckUpdates::VersionScope::MAJOR

    attr_accessor :name
    attr_accessor :latest_version
    attr_accessor :current_version
    attr_accessor :version_range

    def initialize(name: nil,
                   current_version: nil,
                   version_range: nil,
                   latest_version: nil,
                   update_scope: DEFAULT_SCOPE)
      @name = name
      @current_version = current_version
      @version_range = version_range
      @latest_version = latest_version
      @update_scope = update_scope
    end

    def update_available?
      !@latest_version.nil? &&
        !@current_version.nil? &&
        @current_version != '0' &&
        @latest_version > @current_version
    end

    def scoped_latest_version(versions)
      # Ignore pre release version (ex. beta, rc), and sort desc
      numbers = versions.map { |v| v['number'] }
                        .select { |v| v.split('.').size < 4 }
                        .sort_by { |v| v.split('.').map(&:to_i)[0, 3] }
                        .reverse
      current_major, current_minor = @current_version.split('.')

      case @update_scope
      when GemCheckUpdates::VersionScope::MINOR
        numbers.select { |n| n.split('.').first == current_major }.first
      when GemCheckUpdates::VersionScope::PATCH
        numbers.select do |n|
          major, minor = n.split('.')
          major == current_major && minor == current_minor
        end.first
      else
        # This branch is equal to specifying major updates
        numbers.first
      end
    end

    def highlighted_latest_version
      Array.new(3) do |i|
        c = @current_version.split('.')[i]
        l = @latest_version.split('.')[i]

        c == l ? l : l.green
      end.join('.')
    end
  end
end
