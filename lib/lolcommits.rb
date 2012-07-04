$:.unshift File.expand_path('.')

require "lolcommits/version"
require 'lolcommits/configuration'
require 'lolcommits/capture_mac'
require 'lolcommits/capture_linux'
require 'lolcommits/capture_windows'
require 'lolcommits/git_info'
require 'lolcommits/runner'

require "tranzlate/lolspeak"
require "choice"
require "fileutils"
require "git"
require "RMagick"
require "open3"
require 'httmultiparty'
require 'active_support/inflector'

include Magick

module Lolcommits

end
