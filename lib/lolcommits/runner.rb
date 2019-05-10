# frozen_string_literal: true

require 'lolcommits/platform'

module Lolcommits
  class Runner
    attr_accessor :capture_delay, :capture_stealth, :capture_device, :message,
                  :sha, :snapshot_loc, :main_image, :config, :vcs_info,
                  :capture_animate, :video_loc, :main_video

    def initialize(attributes = {})
      attributes.each do |attr, val|
        send("#{attr}=", val)
      end

      return unless sha.nil? || message.nil?

      if GitInfo.repo_root?
        self.vcs_info = GitInfo.new
      elsif MercurialInfo.repo_root?
        self.vcs_info = MercurialInfo.new
      else
        raise('Unknown VCS')
      end

      self.sha     = vcs_info.sha if sha.nil?
      self.message = vcs_info.message if message.nil?
    end

    def execute_plugins_for(hook)
      debug "#{self.class}: running all enabled plugin hooks for #{hook}"
      enabled_plugins.each do |plugin|
        if plugin.valid_configuration?
          plugin.send("run_#{hook}")
        else
          puts "Warning: skipping plugin #{plugin.name} (invalid configuration, fix with: lolcommits --config -p #{plugin.name})"
        end
      end
    end

    # wrap run to handle things that should happen before and after
    # this used to be handled with ActiveSupport::Callbacks, but
    # now we're just using a simple procedural list
    def run
      # do plugins that need to happen before capture
      execute_plugins_for(:pre_capture)

      # do main capture to snapshot_loc
      run_capture

      # check capture succeded, file must exist
      if File.exist?(snapshot_loc) || (capture_animated? && File.exist?(video_loc))

        # execute post_capture plugins, use to alter the capture
        resize_snapshot! if File.exist?(snapshot_loc)
                
        execute_plugins_for(:post_capture)

        make_animated_gif if capture_animated?

        # execute capture_ready plugins, capture is ready for export/sharing
        execute_plugins_for(:capture_ready)

        # clean away any tmp files
        cleanup!
      else
        debug 'Runner: failed to capture a snapshot'
        exit 1
      end
    end

    # the main capture
    def run_capture
      puts '*** Preserving this moment in history.' unless capture_stealth
      self.snapshot_loc = config.raw_image(image_file_type)
      self.main_image   = config.main_image(sha, image_file_type)
      self.main_video   = config.main_image(sha, 'mp4')
      self.video_loc    = config.video_loc

      capturer = Platform.capturer_class(capture_animated?).new(
        capture_device: capture_device,
        capture_delay: capture_delay,
        snapshot_location: snapshot_loc,
        video_location: config.video_loc,
        frames_location: config.frames_loc,
        animated_duration: capture_animate
      )
      capturer.capture
    end

    def capture_animated?
      capture_animate > 0
    end

    private

    def capture_delay_string
      " -ss #{capture_delay}" if capture_delay.to_i > 0
    end

    def frame_delay(fps, skip)
      # calculate frame delay
      delay = ((100.0 * skip) / fps.to_f).to_i
      delay < 6 ? 6 : delay # hard limit for IE browsers
    end

    def video_fps(file)
      # inspect fps of the captured video file (default to 29.97)
      fps = system_call("ffmpeg -nostats -v quiet -i \"#{file}\" 2>&1 | sed -n \"s/.*, \\(.*\\) fp.*/\\1/p\"", true)
      fps.to_i < 1 ? 29.97 : fps.to_f
    end

    def frame_skip(fps)
      # of frames to skip depends on movie fps
      case fps
      when 0..15
        2
      when 16..28
        3
      else
        4
      end
    end

    def make_animated_gif
      null_string = "/dev/null"
      if Lolcommits::Platform.platform_windows?
        null_string = "nul"
      end
      system_call "ffmpeg #{capture_delay_string} -nostats -v quiet -i \"#{main_video}\" -t #{capture_animate} \"#{config.frames_loc}/%09d.png\" > #{null_string}"

      # use fps to set delay and number of frames to skip (for lower filesized gifs)
      fps   = video_fps(main_video)
      skip  = frame_skip(fps)
      delay = frame_delay(fps, skip)
      debug "Capturer: animated gif choosing every #{skip} frames with a frame delay of #{delay} (video fps: #{fps})"

      # create the looping animated gif from frames (delete frame files except every #{skip} frame)
      Dir["#{config.frames_loc}/*.png"].each do |frame_filename|
          basename = File.basename(frame_filename)
          frame_number = basename.split('.').first.to_i
          File.delete(frame_filename) if frame_number % skip != 0
      end

      # convert to animated gif with delay and gif optimisation
      system_call "convert -layers OptimizeTransparency -delay #{delay} -loop 0 \"#{config.frames_loc}/*.png\" -coalesce \"#{snapshot_loc}\""
    end

    def enabled_plugins
      @enabled_plugins ||= config.plugin_manager.enabled_plugins_for(self)
    end

    def image_file_type
      capture_animated? ? 'gif' : 'jpg'
    end

    def resize_snapshot!
      debug 'Runner: resizing snapshot'
      image = MiniMagick::Image.open(snapshot_loc)
      if image[:width] > 640 || image[:height] > 480
        # this is hacky resize-to-fill
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

    def system_call(call_str, capture_output = false)
      debug "Capturer: making system call for \n #{call_str}"
      capture_output ? `#{call_str}` : system(call_str)
    end


    def cleanup!
      debug 'Runner: running cleanup'
      # clean up the captured image and any other raw assets
      FileUtils.rm(snapshot_loc) if File.exists?(snapshot_loc)
      FileUtils.rm_f(config.video_loc)
      FileUtils.rm_rf(config.frames_loc)
    end
  end
end
