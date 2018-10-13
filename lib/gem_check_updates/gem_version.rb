# frozen_string_literal: true

module GemCheckUpdates
  class GemVersion
    include Comparable

    attr_accessor :number
    attr_accessor :major
    attr_accessor :minor
    attr_accessor :patch
    attr_accessor :pre
    attr_accessor :pre_release

    def initialize(number: '0', pre_release: false)
      @number = number
      @major, @minor, @patch, @pre = number.split('.').concat(%w[0 0 0 0])
      @pre_release = pre_release
    end

    def version_specified?
      @number != '0'
    end

    def <=>(other)
      weighted_version <=> other.weighted_version
    end

    def to_s
      @number
    end

    def weighted_version
      weights = [100, 10, 1]

      [@major, @minor, @patch].map(&:to_i)
                              .map.with_index { |n, i| n * weights[i] }
    end
  end
end
