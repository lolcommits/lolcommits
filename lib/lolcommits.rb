$LOAD_PATH.unshift File.expand_path('.')

require 'core_ext/hash/hash_dig' # backport Hash#dig for Ruby < 2.3

require 'mini_magick'
require 'core_ext/mini_magick/utilities'
require 'fileutils'
require 'git'
require 'open3'
require 'methadone'
require 'date'
require 'mercurial-ruby'
require 'core_ext/mercurial-ruby/shell'

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

# backends
require 'lolcommits/backends/installation_git'
require 'lolcommits/backends/installation_mercurial'
require 'lolcommits/backends/git_info'
require 'lolcommits/backends/mercurial_info'

# require runner after all the plugins have been required
require 'lolcommits/runner'
