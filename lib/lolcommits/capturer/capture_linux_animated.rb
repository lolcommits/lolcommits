# -*- encoding : utf-8 -*-
module Lolcommits
  class CaptureLinuxAnimated < Capturer
    def capture
      # make a fresh frames directory
      FileUtils.rm_rf(frames_location)
      FileUtils.mkdir_p(frames_location)

      # capture the raw video with ffmpeg video4linux2
      system_call "ffmpeg -v quiet -y -f video4linux2 -video_size 320x240 -i #{capture_device_string} -t #{capture_duration} #{video_location} > /dev/null"
      if File.exists?(video_location)
        # convert raw video to png frames with ffmpeg
        system_call "ffmpeg #{capture_delay_string} -v quiet -i #{video_location} -t #{animated_duration} #{frames_location}/%09d.png > /dev/null"

        # use fps to set delay and number of frames to skip (for lower filesized gifs)
        fps   = video_fps(video_location)
        skip  = frame_skip(fps)
        delay = frame_delay(fps, skip)
        debug "Capturer: anaimated gif choosing every #{skip} frames with a frame delay of #{delay}"

        # create the looping animated gif from frames (picks nth frame with seq)
        seq_command = "seq -f #{frames_location}/%09g.png 1 #{skip} #{Dir["#{frames_location}/*"].length}"
        # convert to animated gif with delay and gif optimisation
        system_call "convert -layers OptimizeTransparency -delay #{delay} -loop 0 `#{seq_command}` -coalesce #{snapshot_location} > /dev/null"
      end
    end

    private

    def system_call(call_str, capture_output = false)
      debug "Capturer: making system call for \n #{call_str}"
      capture_output ? `#{call_str}` : system(call_str)
    end

    def frame_delay(fps, skip)
      # calculate frame delay
      delay = ((100.0 * skip) / fps.to_f).to_i
      delay < 6 ? 6 : delay # hard limit for IE browsers
    end

    def video_fps(file)
      # inspect fps of the captured video file (default to 29.97)
      fps = system_call("ffmpeg -i #{file} 2>&1 | sed -n \"s/.*, \\(.*\\) fp.*/\\1/p\"", true)
      fps.to_i < 1 ? 29.97 : fps.to_f
    end

    def frame_skip(fps)
      # of frames to skip depends on movie fps
      case (fps)
      when 0..15
        2
      when 16..28
        3
      else
        4
      end
    end

    def capture_device_string
      "'#{capture_device}' " if capture_device
    end

    def capture_delay_string
      " -ss #{capture_delay}" if capture_delay.to_i > 0
    end

    def capture_duration
      animated_duration.to_i + capture_delay.to_i
    end
  end
end
