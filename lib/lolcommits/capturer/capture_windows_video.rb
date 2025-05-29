module Lolcommits
  class CaptureWindowsVideo < Capturer
    def capture
      return unless capture_device_string

      system_call "ffmpeg -v quiet -y -f dshow -i video=\"#{capture_device_string}\" -video_size 640x480 -t #{capture_duration} \"#{capture_path}\" > NUL"
    end

    private
      def capture_device_string
        capture_device || device_names.first
      end

      def ffpmeg_list_devices_cmd
        "ffmpeg -list_devices true -f dshow -i dummy 2>&1"
      end

      # inspired by this code from @rdp http://tinyurl.com/y7t276bh
      def device_names
        @device_names ||= begin
          names      = []
          cmd_output = ""
          count      = 0
          while cmd_output.empty? || !cmd_output.split("DirectShow")[2]
            cmd_output = system_call(ffpmeg_list_devices_cmd, capture_output: true)
            count += 1
            raise "failed to find a video capture device with ffmpeg -list_devices" if count == 5

            sleep 0.1
          end
          cmd_output.gsub!("\r\n", "\n")
          video = cmd_output.split("DirectShow")[1]

          video.lines.map do |line|
            names << Regexp.last_match(1) if line =~ /"(.+)"\n/
          end

          debug "found #{names.length} video devices: #{names.join(', ')}"
          names
        end
      end
  end
end
