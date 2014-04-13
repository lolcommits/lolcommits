# -*- encoding : utf-8 -*-
module Lolcommits
  PLUGINS = Lolcommits::Plugin.subclasses

  class Runner
    attr_accessor :capture_delay, :capture_stealth, :capture_device, :message, :sha,
                  :snapshot_loc, :main_image, :repo, :config, :repo_internal_path,
                  :font, :capture_animate, :url

    include Methadone::CLILogging

    def initialize(attributes = {})
      attributes.each do |attr, val|
        self.send("#{attr}=", val)
      end

      if self.sha.nil? || self.message.nil?
        git_info = GitInfo.new
        self.sha = git_info.sha if self.sha.nil?
        self.message = git_info.message if self.message.nil?
        self.repo_internal_path = git_info.repo_internal_path
        self.repo = git_info.repo
        self.url  = git_info.url
      end
    end

    # wrap run to handle things that should happen before and after
    # this used to be handled with ActiveSupport::Callbacks, but
    # now we're just using a simple procedural list
    def run
      # do things that need to happen before capture and plugins

      # do native plugins that need to happen before capture
      plugins_for(:precapture).each do |plugin|
        debug "precapture: about to execute #{plugin}"
        plugin.new(self).execute
      end

      # do gem plugins that need to happen before capture?

      # **** do the main capture ****
      run_capture_and_resize

      # do native plugins that need to happen immediately after capture
      # this is effectively the "image processing" phase
      # for now, reserve just for us and handle manually...?
      Lolcommits::Loltext.new(self).execute

      # do native plugins that need to happen after capture
      plugins_for(:postcapture).each do |plugin|
        plugin.new(self).execute
      end

      # do gem plugins that need to happen after capture?

      # do things that should happen last
      cleanup!
    end

    def plugins_for(position)
      Lolcommits::PLUGINS.select { |p| p.runner_order == position }
    end

    # the main capture and resize operation, critical
    def run_capture_and_resize
      die_if_rebasing!

      puts '*** Preserving this moment in history.' unless capture_stealth
      self.snapshot_loc = self.config.raw_image(image_file_type)
      self.main_image   = self.config.main_image(self.sha, image_file_type)
      capturer = capturer_class.new(
        :capture_device    => self.capture_device,
        :capture_delay     => self.capture_delay,
        :snapshot_location => self.snapshot_loc,
        :font              => self.font,
        :video_location    => self.config.video_loc,
        :frames_location   => self.config.frames_loc,
        :animated_duration => self.capture_animate
      )
      capturer.capture
      resize_snapshot!
    end

    def animate?
      capture_animate && (capture_animate.to_i > 0)
    end

    private

    def capturer_class
      Object.const_get("Lolcommits::Capture#{Configuration.platform}#{animate? ? 'Animated' : nil}")
    end

    def image_file_type
      animate? ? 'gif' : 'jpg'
    end
  end

  protected

  def die_if_rebasing!
    debug "Runner: Making sure user isn't rebasing"
    if not self.repo_internal_path.nil?
      mergeclue = File.join self.repo_internal_path, 'rebase-merge'
      if File.directory? mergeclue
        debug 'Runner: Rebase detected, silently exiting!'
        exit 0
      end
    end
  end

  def resize_snapshot!
    debug 'Runner: resizing snapshot'
    image = MiniMagick::Image.open(self.snapshot_loc)
    if image[:width] > 640 || image[:height] > 480
      # this is ghetto resize-to-fill
      image.combine_options do |c|
        c.resize '640x480^'
        c.gravity 'center'
        c.extent '640x480'
      end
      debug "Runner: writing resized image to #{self.snapshot_loc}"
      image.write self.snapshot_loc
    end
    debug "Runner: copying resized image to #{self.main_image}"
    FileUtils.cp(self.snapshot_loc, self.main_image)
  end

  def cleanup!
    debug 'Runner: running cleanup'
    # clean up the captured image and any other raw assets
    FileUtils.rm(self.snapshot_loc)
    FileUtils.rm_f(self.config.video_loc)
    FileUtils.rm_rf(self.config.frames_loc)
  end
end
