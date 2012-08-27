module Lolcommits
  class CaptureWindows < Capturer
    def capture
      commandcam_exe = File.join Configuration::LOLCOMMITS_ROOT, "vendor", "ext", "CommandCam", "CommandCam.exe"
      # DirectShow takes a while to show... at least for me anyway
      delaycmd = " /delay 3000"
      if capture_delay > 0
        # CommandCam delay is in milliseconds
        delaycmd = " /delay #{capture_delay * 1000}"
      end
      _, r, _ = Open3.popen3("#{commandcam_exe} /filename #{snapshot_location}#{delaycmd}")
      # looks like we still need to read the output for something to happen
      r.read
    end

  end

end
