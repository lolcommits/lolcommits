module Lolcommits
  class CaptureMac < Capturer
    def capture_device_string
      @capture_device.nil? ? nil : "-d \"#{@capture_device}\""
    end

    def capture
      # TODO: check we have a webcam we can capture from first. See issue #219
      # operating laptop in clamshell (lid closed) from 2nd desktop screen,
      # needs to better handle  the capturer (imagesnap, videosnap
      # CommandCam, mplayer) return code or check with an option before
      # attempting capture. Alt solution is puttin in prompt mode option :(
      call_str = "#{executable_path} -q \"#{snapshot_location}\" -w #{capture_delay} #{capture_device_string}"
      debug "Capturer: making system call for #{call_str}"
      system(call_str)
    end

    def executable_path
      File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'imagesnap', 'imagesnap')
    end
  end
end
