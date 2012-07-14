$:.unshift File.expand_path('.')

require 'core_ext/class'
require "lolcommits/version"
require 'lolcommits/configuration'
require 'lolcommits/capture_mac'
require 'lolcommits/capture_linux'
require 'lolcommits/capture_windows'
require 'lolcommits/git_info'
require 'lolcommits/plugin'
require 'lolcommits/plugins/loltext'
require 'lolcommits/plugins/dot_com'
require 'lolcommits/plugins/tranzlate'

require "tranzlate/lolspeak"
require "choice"
require "fileutils"
require "git"
require "RMagick"
require "open3"
require 'httmultiparty'
require 'active_support/inflector'
require 'active_support/concern'
require 'active_support/callbacks'

# require runner after all the plugins have been required
require 'lolcommits/runner'
include Magick
