# frozen_string_literal: true

module Lolcommits
  class AnimatedGif
    def create(video_path:, output_path:)
      unless File.exist?(video_path)
        debug "**warning** unable to create animated gif, no video at #{video_path}"
        return
      end

      debug "creating animated gif at #{output_path}"
      system_call "ffmpeg -nostats -v quiet -i \"#{video_path}\" \"#{frames_dir}/%09d.png\" > #{null_string}"

      # use fps to set delay and number of frames to skip (for lower filesized gifs)
      fps   = video_fps(video_path)
      skip  = frame_skip(fps)
      delay = frame_delay(fps, skip)
      debug "animated gif choosing every #{skip} frames with a frame delay of #{delay} (video fps: #{fps})"

      # create the looping animated gif from frames (delete frame files except every #{skip} frame)
      Dir["#{frames_dir}/*.png"].each do |frame_filename|
        basename = File.basename(frame_filename)
        frame_number = basename.split('.').first.to_i
        File.delete(frame_filename) if frame_number % skip != 0
      end

      # convert to animated gif with delay and gif optimisation
      system_call "convert -layers OptimizeTransparency -delay #{delay} -loop 0 \"#{frames_dir}/*.png\" -coalesce \"#{output_path}\""

      # remove tmp frames dir
      FileUtils.rm_rf(frames_dir)
    end

    private

    def frames_dir
      @frames_dir ||= Dir.mktmpdir
    end

    def null_string
      Lolcommits::Platform.platform_windows? ? 'nul' : '/dev/null'
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

    def system_call(call_str, capture_output = false)
      debug "making system call for \n #{call_str}"
      capture_output ? `#{call_str}` : system(call_str)
    end

    def debug(message)
      super("#{self.class}: #{message}")
    end
  end
end
