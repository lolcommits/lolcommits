# frozen_string_literal: true

module Lolcommits
  class CaptureWindowsAnimated < Capturer
    def capture
      # make a fresh frames directory
      FileUtils.rm_rf(frames_location)
      FileUtils.mkdir_p(frames_location)

      # abort capture if we don't have a device name
      return unless capture_device_string

      # capture raw video with ffmpeg dshow
      system_call "ffmpeg -v quiet -y -f dshow -i video=\"#{capture_device_string}\" -video_size 640x480 -t #{capture_duration} \"#{video_location}\" > NUL"
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
