module Lolcommits
  class CaptureWindows < Capturer
    def capture
      # DirectShow takes a while to show... at least for me anyway
      delaycmd = ' /delay 3000'
      if capture_delay > 0
        # CommandCam delay is in milliseconds
        delaycmd = " /delay #{capture_delay * 1000}"
      end

      _stdin, stdout, _stderr = Open3.popen3("#{executable_path} /filename #{snapshot_location}#{delaycmd}")

      # looks like we still need to read the output for something to happen
      stdout.read
    end

    def executable_path
      File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'CommandCam', 'CommandCam.exe')
    end
  end
end
