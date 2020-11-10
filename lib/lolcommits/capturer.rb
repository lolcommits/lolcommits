# frozen_string_literal: true

module Lolcommits
  class Capturer
    attr_accessor :capture_device, :capture_delay, :capture_duration,
                  :capture_path

    def initialize(attributes = {})
      attributes.each do |attr, val|
        send("#{attr}=", val)
      end
    end

    def system_call(call_str, capture_output: false)
      debug "making system call for \n #{call_str}"
      capture_output ? `#{call_str}` : system(call_str)
    end

    def debug(message)
      super("#{self.class}: #{message}")
    end
  end
end

require 'lolcommits/capturer/capture_mac'
require 'lolcommits/capturer/capture_mac_video'
require 'lolcommits/capturer/capture_linux'
require 'lolcommits/capturer/capture_linux_video'
require 'lolcommits/capturer/capture_windows'
require 'lolcommits/capturer/capture_windows_video'
require 'lolcommits/capturer/capture_cygwin'
require 'lolcommits/capturer/capture_fake'
