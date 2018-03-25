module Lolcommits
  class CaptureWindowsAnimated < Capturer
    def capture
      # make a fresh frames directory
      FileUtils.rm_rf(frames_location)
      FileUtils.mkdir_p(frames_location)

      # abort capture if we don't have a device name
      return unless capture_device_string

      # capture raw video with ffmpeg dshow
      system_call "ffmpeg -v quiet -y -f dshow -i video=\"#{capture_device_string}\" -video_size 320x240 -t #{capture_duration} \"#{video_location}\" > NUL"

      return unless File.exist?(video_location)
      # convert raw video to png frames with ffmpeg
      system_call "ffmpeg #{capture_delay_string} -v quiet -i \"#{video_location}\" -t #{animated_duration} \"#{frames_location}/%09d.png\" > NUL"

      # use fps to set delay and number of frames to skip (for lower filesized gifs)
      fps   = video_fps(video_location)
      skip  = frame_skip(fps)
      delay = frame_delay(fps, skip)
      debug "Capturer: animated gif choosing every #{skip} frames with a frame delay of #{delay} (video fps: #{fps})"

      # create the looping animated gif from frames (delete frame files except every #{skip} frame)
      Dir["#{frames_location}/*.png"].each do |frame_filename|
        basename = File.basename(frame_filename)
        frame_number = basename.split('.').first.to_i
        File.delete(frame_filename) if frame_number % skip != 0
      end

      # convert to animated gif with delay and gif optimisation
      system_call "convert -layers OptimizeTransparency -delay #{delay} -loop 0 \"#{frames_location}/*.png\" -coalesce \"#{snapshot_location}\""
    end

    private

    def ffpmeg_list_devices_cmd
      'ffmpeg -list_devices true -f dshow -i dummy 2>&1'
    end

    # inspired by this code from @rdp http://tinyurl.com/y7t276bh
    def device_names
      @device_names ||= begin
        names      = []
        cmd_output = ''
        count      = 0
        while cmd_output.empty? || !cmd_output.split('DirectShow')[2]
          cmd_output = system_call(ffpmeg_list_devices_cmd, true)
          count += 1
          raise 'failed to find a video capture device with ffmpeg -list_devices' if count == 5
          sleep 0.1
        end
        cmd_output.gsub!("\r\n", "\n")
        video = cmd_output.split('DirectShow')[1]

        video.lines.map do |line|
          names << Regexp.last_match(1) if line =~ /"(.+)"\n/
        end

        debug "Capturer: found #{names.length} video devices: #{names.join(', ')}"
        names
      end
    end

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
      capture_device || device_names.first
    end

    def capture_delay_string
      " -ss #{capture_delay}" if capture_delay.to_i > 0
    end

    def capture_duration
      animated_duration.to_i + capture_delay.to_i
    end
  end
end
