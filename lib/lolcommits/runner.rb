# frozen_string_literal: true

require 'lolcommits/platform'
require 'lolcommits/animated_gif'

module Lolcommits
  class Runner
    attr_accessor :capture_delay, :capture_stealth, :capture_device,
                  :capture_duration, :capture_path, :capture_video,
                  :capture_gif, :sha, :message, :config, :vcs_info,
                  :lolcommit_path, :lolcommit_gif_path

    def initialize(attributes = {})
      attributes.each do |attr, val|
        send("#{attr}=", val)
      end

      if GitInfo.repo_root?
        self.vcs_info = GitInfo.new
      elsif MercurialInfo.repo_root?
        self.vcs_info = MercurialInfo.new
      end

      if vcs_info
        self.sha ||= vcs_info.sha
        self.message ||= vcs_info.message
      end

      return unless config

      self.capture_path       = config.capture_path(lolcommit_ext)
      self.lolcommit_path     = config.sha_path(sha, lolcommit_ext)
      self.lolcommit_gif_path = config.sha_path(sha, 'gif') if capture_gif
    end

    def run
      execute_plugins_for(:pre_capture)

      # main capture
      run_capture

      # capture must exist to run post capture methods
      unless File.exist?(capture_path)
        raise 'failed to capture any image or video!'
      end

      run_post_capture
      run_capture_ready
    rescue StandardError => e
      debug("#{e.class}: #{e.message}")
      exit 1
    ensure
      debug 'running cleanup'
      FileUtils.rm_f(capture_path)
    end

    # return MiniMagick overlay png for manipulation (or create one)
    def overlay
      @overlay ||= begin
        source_path = capture_image? ? lolcommit_path : capture_path
        unless File.exist?(source_path)
          raise "too early to overlay, capture doesn't exist yet"
        end

        base = MiniMagick::Image.open(source_path)
        png_tempfile = MiniMagick::Utilities.tempfile('.png')
        debug("creating a new empty overlay png for lolcommit (#{base.dimensions.join('x')})")

        MiniMagick::Tool::Convert.new do |i|
          i.size "#{base.width}x#{base.height}"
          i.xc 'transparent'
          i << png_tempfile.path
        end

        MiniMagick::Image.open(png_tempfile.path)
      end
    end

    # backward compatibility with earlier plugin releases
    # remove this when all plugins target 0.14+
    def main_image
      capture_gif ? lolcommit_gif_path : lolcommit_path
    end

    private

    def execute_plugins_for(hook)
      debug "running all enabled #{hook} plugin hooks"
      enabled_plugins.each do |plugin|
        if plugin.valid_configuration?
          plugin.send("run_#{hook}")
        else
          puts "Warning: skipping plugin #{plugin.name} (invalid configuration, fix with: lolcommits --config -p #{plugin.name})"
        end
      end
    end

    def capture_image?
      capture_duration.to_i.zero?
    end

    def run_capture
      puts '*** Preserving this moment in history.' unless capture_stealth
      capturer = Platform.capturer_class(!capture_image?).new(
        capture_path: capture_path,
        capture_device: capture_device,
        capture_delay: capture_delay,
        capture_duration: capture_duration
      )
      capturer.capture
    end

    def run_post_capture
      resize_captured_image if capture_image?

      execute_plugins_for(:post_capture)

      # apply overlay if present, or cp video to lolcommit_path
      if @overlay
        apply_overlay
      elsif !capture_image?
        FileUtils.cp(capture_path, lolcommit_path)
      end

      # optionally create animated gif
      return unless capture_gif

      AnimatedGif.new.create(
        video_path: lolcommit_path,
        output_path: lolcommit_gif_path
      )

      # done if we are capturing both video and gif
      return if capture_video

      # remove video and assign var (if only capturing gif)
      FileUtils.rm_f(lolcommit_path)
      self.lolcommit_path = lolcommit_gif_path
    end

    def run_capture_ready
      debug "lolcommit_path: #{lolcommit_path}"
      debug "lolcommit_gif_path: #{lolcommit_gif_path}"
      execute_plugins_for(:capture_ready)
    end

    def resize_captured_image
      image = MiniMagick::Image.open(capture_path)

      if image.width > 640 || image.height > 480
        debug "resizing raw image (#{image.dimensions.join('x')}) to #{lolcommit_path} (640x480)"
        # hacky resize to fill bounds
        image.combine_options do |c|
          c.resize '640x480^'
          c.gravity 'center'
          c.extent '640x480'
        end
        image.write(lolcommit_path)
      else
        debug "no resize needed, copying raw image to #{lolcommit_path} (640x480)"
        FileUtils.cp(capture_path, lolcommit_path)
      end
    end

    def apply_overlay
      debug 'applying overlay to lolcommit'
      if capture_image?
        MiniMagick::Image.open(lolcommit_path).composite(overlay) do |c|
          c.gravity 'center'
        end.write(lolcommit_path)
      else
        system_call "ffmpeg -v quiet -nostats -i #{capture_path} -i #{overlay.path} \
          -filter_complex overlay=0:0 \
          -y #{lolcommit_path}"
      end
    end

    def lolcommit_ext
      if capture_image?
        'jpg'
      else
        'mp4'
      end
    end

    def enabled_plugins
      @enabled_plugins ||= config.plugin_manager.enabled_plugins_for(self)
    end

    def system_call(call_str, capture_output = false)
      debug "making system call for \n #{call_str}"
      capture_output ? `#{call_str}` : system(call_str)
    end

    def debug(message)
      super("#{self.class}: #{message}")
    end
  end
end
