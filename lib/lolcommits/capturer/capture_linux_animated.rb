module Lolcommits
  class CaptureLinuxAnimated < Capturer
    def capture
      # make a fresh frames directory
      FileUtils.rm_rf(frames_location)
      FileUtils.mkdir_p(frames_location)

      # capture the raw video with ffmpeg video4linux2
      system_call "ffmpeg -nostats -v quiet -y -f video4linux2 -video_size 640x480 -i #{capture_device_string} -t #{capture_duration} \"#{video_location}\" > /dev/null"
    end

    private

    def system_call(call_str, capture_output = false)
      debug "Capturer: making system call for \n #{call_str}"
      capture_output ? `#{call_str}` : system(call_str)
    end

    def capture_device_string
      capture_device || '/dev/video0'
    end

    def capture_delay_string
      " -ss #{capture_delay}" if capture_delay.to_i > 0
    end

    def capture_duration
      animated_duration.to_i + capture_delay.to_i
    end
  end
end
