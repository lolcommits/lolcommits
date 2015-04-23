# -*- encoding : utf-8 -*-
require 'mini_magick'
require 'rbconfig'

module Lolcommits
  class Platform
    # A convenience name for the platform.  Mainly used for metaprogramming.
    # @return String
    def self.platform
      if platform_mac?        then 'Mac'
      elsif platform_linux?   then 'Linux'
      elsif platform_windows? then 'Windows'
      elsif platform_cygwin?  then 'Cygwin'
      else
        fail 'Unknown / Unsupported Platform.'
      end
    end

    # The capturer class constant to use
    # @return Class
    def self.capturer_class(animate = false)
      Object.const_get('Lolcommits').const_get(
        ENV['LOLCOMMITS_CAPTURER'] || "Capture#{platform}#{animate ? 'Animated' : nil}"
      )
    end

    # Are we on a Mac platform?
    # @return Boolean
    def self.platform_mac?
      host_os.include?('darwin')
    end

    # Are we on a Linux platform?
    # @return Boolean
    def self.platform_linux?
      host_os.include?('linux')
    end

    # Are we on a Windows platform?
    # @return Boolean
    def self.platform_windows?
      !host_os.match(/(win|w)32/).nil?
    end

    # Are we on a Cygwin platform?
    # @return Boolean
    def self.platform_cygwin?
      host_os.include?('cygwin')
    end

    # return host_os identifier from the RbConfig::CONFIG constant
    # @return String
    def self.host_os
      ENV['LOLCOMMITS_FAKE_HOST_OS'] || RbConfig::CONFIG['host_os'].downcase
    end

    # Is the platform capable of capturing animated GIFs from webcam?
    # @return Boolean
    def self.can_animate?
      platform_linux? || platform_mac?
    end

    # Is a valid install of imagemagick present on the system?
    # @return Boolean
    def self.valid_imagemagick_installed?
      return false unless command_which('identify')
      return false unless command_which('mogrify')
      # you'd expect the below to work on its own, but it only handles old versions
      # and will throw an exception if IM is not installed in PATH
      MiniMagick.valid_version_installed?
    rescue
      return false
    end

    # Is a valid install of ffmpeg present on the system?
    #
    # @note For now, this just checks for presence, any version should work.
    # @return Boolean
    def self.valid_ffmpeg_installed?
      command_which('ffmpeg')
    end

    # Cross-platform way of finding an executable in the $PATH.
    #
    # Idea taken from http://bit.ly/qDaTbY, if only_path is true, only the path
    # is returned (not the path and command)
    #
    # @example
    #   command_which('ruby') #=> /usr/bin/ruby
    #
    # @return Boolean
    def self.command_which(cmd, only_path = false)
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = "#{path}/#{cmd}#{ext}"
          return only_path ? path : exe if File.executable? exe
        end
      end
      nil
    end

    # Is `git config color.ui` set to 'always'?
    #
    # Due to a bug in the ruby-git library, git config for color.ui cannot be
    # set to 'always' or it won't read properly.
    #
    # This helper method let's us check for that error condition so we can
    # alert the user in the CLI tool.
    #
    # @return Boolean
    def self.git_config_color_always?
      `git config color.ui`.chomp =~ /always/
    end

    # Returns a list of system camera devices in a format suitable to display
    # to the user.
    #
    # @note Currently only functions on Mac.
    # @return String
    def self.device_list
      # TODO: handle other platforms here (linux/windows)
      if Platform.platform_mac?
        capturer = Lolcommits::CaptureMacAnimated.new
        `#{capturer.executable_path} -l`
      end
    end
  end
end
