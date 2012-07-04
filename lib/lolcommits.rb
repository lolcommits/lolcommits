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

  def capture(capture_delay=0, capture_device=nil, is_test=false, test_msg=nil, test_sha=nil)
    runner = Lolcommits::Runner.new(:capture_delay => capture_delay,
                                    :capture_device => capture_device,
                                    :message => test_msg,
                                    :sha => test_sha)
    runner.run

    runner.sha
  end
end
