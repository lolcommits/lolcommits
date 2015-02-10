# -*- encoding : utf-8 -*-
require 'mini_magick'

module Lolcommits
  module Helper
    class Platform
      def self.platform
        if platform_fakeplatform?
          ENV['LOLCOMMITS_FAKEPLATFORM']
        elsif platform_fakecapture?
          'Fake'
        elsif platform_mac?
          'Mac'
        elsif platform_linux?
          'Linux'
        elsif platform_windows?
          'Windows'
        elsif platform_cygwin?
          'Cygwin'
        else
          fail 'Unknown / Unsupported Platform.'
        end
      end

      def self.platform_mac?
        RUBY_PLATFORM.to_s.downcase.include?('darwin')
      end

      def self.platform_linux?
        RUBY_PLATFORM.to_s.downcase.include?('linux')
      end

      def self.platform_windows?
        !!RUBY_PLATFORM.match(/(win|w)32/)
      end

      def self.platform_cygwin?
        RUBY_PLATFORM.to_s.downcase.include?('cygwin')
      end

      def self.platform_fakecapture?
        (ENV['LOLCOMMITS_FAKECAPTURE'] == '1' || false)
      end

      def self.platform_fakeplatform?
        ENV['LOLCOMMITS_FAKEPLATFORM']
      end

      def self.can_animate?
        ['Mac', 'Linux'].include? platform
      end

      def self.valid_imagemagick_installed?
        return false unless self.command_which('identify')
        return false unless self.command_which('mogrify')
        # you'd expect the below to work on its own, but it only handles old versions
        # and will throw an exception if IM is not installed in PATH
        MiniMagick.valid_version_installed?
      rescue
        puts "FATAL: ImageMagick >= #{MiniMagick.minimum_image_magick_version} required (http://imagemagick.org)"
        puts 'Please check the following command works and returns a valid version number'
        puts '=> mogrify --version'
        exit 1
      end

      def self.valid_ffmpeg_installed?
        self.command_which('ffmpeg')
      end

      # Cross-platform way of finding an executable in the $PATH.
      # idea taken from http://bit.ly/qDaTbY, if only_path is true, only the path
      # is returned (not the path and command)
      #
      #   which('ruby') #=> /usr/bin/ruby
      def self.command_which(cmd, only_path = false)
        exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
        ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
          exts.each do |ext|
            exe = "#{path}/#{cmd}#{ext}"
            if File.executable? exe
              return only_path ? path : exe
            end
          end
        end
        nil
      end

      def self.git_config_color_always?
        `git config color.ui`.chomp =~ /always/
      end
    end
  end
end
