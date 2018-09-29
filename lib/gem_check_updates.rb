# frozen_string_literal: true

require 'bundler'
require 'fileutils'
require 'optparse'
require 'rest-client'
require 'colored'
require 'json'
require 'rake'
require 'rake/tasklib'

require 'gem_check_updates/version'
require 'gem_check_updates/version_scope'
require 'gem_check_updates/option'
require 'gem_check_updates/message'
require 'gem_check_updates/gemfile'
require 'gem_check_updates/gem'
require 'gem_check_updates/runner'

module GemCheckUpdates
end
