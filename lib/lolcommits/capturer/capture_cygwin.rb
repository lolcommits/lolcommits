# frozen_string_literal: true

module Lolcommits
  class CaptureCygwin < Capturer
    def capture
      # DirectShow takes a while to show
      delaycmd = ' /delay 3000'
      if capture_delay > 0
        # CommandCam delay is in milliseconds
        delaycmd = " /delay #{capture_delay * 1000}"
      end

      _stdin, stdout, _stderr = Open3.popen3("#{executable_path} /filename `cygpath -w #{capture_path}`#{delaycmd}")

      # need to read the output for something to happen
      stdout.read
    end

    private

    def executable_path
      File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'CommandCam', 'CommandCam.exe')
    end
  end
end
