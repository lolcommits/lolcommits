module Lolcommits
  class CaptureMacAnimated < Capturer
    def capture
      # make a fresh frames directory
      FileUtils.rm_rf(frames_location)
      FileUtils.mkdir_p(frames_location)

      # capture the raw video with videosnap
      system_call "#{executable_path} -s 240 #{capture_device_string}#{capture_delay_string}-t #{animated_duration} --no-audio \"#{video_location}\" > /dev/null"
      return unless File.exist?(video_location)
      # get fps for ffmpeg output stream configuration
      fps = video_fps(video_location)
      # convert raw video to png frames with ffmpeg
      system_call "ffmpeg -v quiet -i \"#{video_location}\" -t #{animated_duration} -r #{fps} \"#{frames_location}/%09d.png\""

      # use fps to set delay and number of frames to skip (for lower filesized gifs)
      skip  = frame_skip(fps)
      delay = frame_delay(fps, skip)
      debug "Capturer: animated gif choosing every #{skip} frames with a frame delay of #{delay} (video fps: #{fps})"

      # create the looping animated gif from frames (picks nth frame with seq,
      # quotes output and concats to a single line with tr)
      seq_command = "seq -f \"\\\"#{frames_location}/%09g.png\\\"\" 1 #{skip} #{Dir["#{frames_location}/*"].length} | tr '\\n' ' '"
      seq_frame_files = system_call(seq_command, true)
      # convert to animated gif with delay and gif optimisation
      system_call "convert -layers OptimizeTransparency -delay #{delay} -loop 0 #{seq_frame_files} -coalesce \"#{snapshot_location}\" > /dev/null"
    end

    def executable_path
      File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'videosnap', 'videosnap')
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
      fps = system_call("ffmpeg -i \"#{file}\" 2>&1 | sed -n \"s/.*, \\(.*\\) fp.*/\\1/p\"", true)
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

    def capture_device_string
      "-d \"#{capture_device}\" " if capture_device
    end

    def capture_delay_string
      "-w \"#{capture_delay}\" " if capture_delay.to_i > 0
    end
  end
end
