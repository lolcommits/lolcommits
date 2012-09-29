$:.unshift File.expand_path('.')

require 'core_ext/class'
require 'RMagick'
require 'fileutils'
require 'git'
require 'open3'
require 'active_support/inflector'
require 'active_support/concern'
require 'active_support/callbacks'

require 'lolcommits/version'
require 'lolcommits/configuration'
require 'lolcommits/capturer'
require 'lolcommits/capture_mac'
require 'lolcommits/capture_linux'
require 'lolcommits/capture_windows'
require 'lolcommits/capture_fake'
require 'lolcommits/git_info'
require 'lolcommits/plugin'
require 'lolcommits/plugins/loltext'
require 'lolcommits/plugins/dot_com'
require 'lolcommits/plugins/tranzlate'
require 'lolcommits/plugins/statsd'
require 'lolcommits/plugins/lol_twitter'

# require runner after all the plugins have been required
require 'lolcommits/runner'
