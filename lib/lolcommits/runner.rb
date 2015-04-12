# -*- encoding : utf-8 -*-
require 'lolcommits/platform'

module Lolcommits
  class Runner
    attr_accessor :capture_delay, :capture_stealth, :capture_device, :message,
                  :sha, :snapshot_loc, :main_image, :config, :font, :git_info,
                  :capture_animate

    include Methadone::CLILogging

    def initialize(attributes = {})
      attributes.each do |attr, val|
        send("#{attr}=", val)
      end

      return unless sha.nil? || message.nil?
      self.git_info = GitInfo.new
      self.sha      = git_info.sha if sha.nil?
      self.message  = git_info.message if message.nil?
    end

    # wrap run to handle things that should happen before and after
    # this used to be handled with ActiveSupport::Callbacks, but
    # now we're just using a simple procedural list
    def run
      # abort if we are in a rebase
      die_if_rebasing!

      # do things that need to happen before capture and plugins

      # do native plugins that need to happen before capture
      plugins_for(:precapture).each do |plugin|
        debug "Runner: precapture about to execute #{plugin}"
        plugin.new(self).execute_precapture
      end

      # do gem plugins that need to happen before capture?

      # do main capture to snapshot_loc
      run_capture

      # check capture succeded, file must exist
      if File.exist?(snapshot_loc)

        ## resize snapshot first
        resize_snapshot!

        # do native plugins that need to happen immediately after capture and
        # resize this is effectively the "image processing" phase for now,
        # reserve just for us and handle manually...?
        Lolcommits::Loltext.new(self).execute_postcapture

        # do native plugins that need to happen after capture
        plugins_for(:postcapture).each do |plugin|
          debug "Runner: postcapture about to execute #{plugin}"
          plugin.new(self).execute_postcapture
        end

        # do gem plugins that need to happen after capture?

        # do things that should happen last
        cleanup!
      else
        debug 'Runner: failed to capture a snapshot'
        exit 1
      end
    end

    def plugins_for(position)
      self.class.plugins.select { |p| p.runner_order == position }
    end

    def self.plugins
      Lolcommits::Plugin.subclasses
    end

    # the main capture
    def run_capture
      puts '*** Preserving this moment in history.' unless capture_stealth
      self.snapshot_loc = config.raw_image(image_file_type)
      self.main_image   = config.main_image(sha, image_file_type)
      capturer = capturer_class.new(
        :capture_device    => capture_device,
        :capture_delay     => capture_delay,
        :snapshot_location => snapshot_loc,
        :font              => font,
        :video_location    => config.video_loc,
        :frames_location   => config.frames_loc,
        :animated_duration => capture_animate
      )
      capturer.capture
    end

    def animate?
      capture_animate && (capture_animate.to_i > 0)
    end

    private

    def capturer_class
      capturer_module = 'Lolcommits'
      capturer_class  = "Capture#{Platform.platform}#{animate? ? 'Animated' : nil}"
      Object.const_get(capturer_module).const_get(capturer_class)
    end

    def image_file_type
      animate? ? 'gif' : 'jpg'
    end
  end

  protected

  def die_if_rebasing!
    debug "Runner: Making sure user isn't rebasing"
    return unless git_info && !git_info.repo_internal_path.nil?
    mergeclue = File.join git_info.repo_internal_path, 'rebase-merge'
    return unless File.directory? mergeclue
    debug 'Runner: Rebase detected, silently exiting!'
    exit 0
  end

  def resize_snapshot!
    debug 'Runner: resizing snapshot'
    image = MiniMagick::Image.open(snapshot_loc)
    if image[:width] > 640 || image[:height] > 480
      # this is ghetto resize-to-fill
      image.combine_options do |c|
        c.resize '640x480^'
        c.gravity 'center'
        c.extent '640x480'
      end
      debug "Runner: writing resized image to #{snapshot_loc}"
      image.write snapshot_loc
    end
    debug "Runner: copying resized image to #{main_image}"
    FileUtils.cp(snapshot_loc, main_image)
  end

  def cleanup!
    debug 'Runner: running cleanup'
    # clean up the captured image and any other raw assets
    FileUtils.rm(snapshot_loc)
    FileUtils.rm_f(config.video_loc)
    FileUtils.rm_rf(config.frames_loc)
  end
end
