# frozen_string_literal: true

module Lolcommits
  class CaptureLinuxVideo < Capturer
    def capture
      system_call "ffmpeg -nostats -v quiet -y -f video4linux2 -video_size 640x480 -i #{capture_device_string} -t #{capture_duration} -ss #{capture_delay || 0} \"#{capture_path}\" > /dev/null"
    end

    private

    def capture_device_string
      capture_device || Dir.glob('/dev/video*').first
    end
  end
end
