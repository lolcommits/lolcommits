# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('.')

require 'mini_magick'
require 'fileutils'
require 'git'
require 'open3'
require 'optparse'
require 'optparse_plus'
require 'date'
require 'mercurial-ruby'

require 'lolcommits/version'
require 'lolcommits/configuration'
require 'lolcommits/capturer'
require 'lolcommits/vcs_info'
require 'lolcommits/installation'
require 'lolcommits/platform'
require 'lolcommits/gem_plugin'
require 'lolcommits/plugin_manager'
require 'lolcommits/plugin/base'

# after lolcommits/platform, so that we can do platform-conditional override
require 'core_ext/mercurial-ruby/command'
require 'core_ext/mercurial-ruby/shell'

# String#encode patched to be Ruby 3.0+ compatible
require 'core_ext/mercurial-ruby/changed_file'
# Mercurial::ConfigFile#exists? patched to be Ruby 3.2+ compatible
require 'core_ext/mercurial-ruby/config_file'
# Mercurial::Repository.open patched to be Ruby 3.2+ compatible
require 'core_ext/mercurial-ruby/repository'

# backends
require 'lolcommits/backends/installation_git'
require 'lolcommits/backends/installation_mercurial'
require 'lolcommits/backends/git_info'
require 'lolcommits/backends/mercurial_info'

# require runner after all the plugins have been required
require 'lolcommits/runner'
