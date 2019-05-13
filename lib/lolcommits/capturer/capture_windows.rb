# frozen_string_literal: true

module Lolcommits
  class CaptureWindows < Capturer
    def capture
      _stdin, stdout, _stderr = Open3.popen3("#{executable_path} /filename #{capture_path}#{delay_arg}")

      # need to read the output for something to happen
      stdout.read
    end

    private

    def delay_arg
      # CommandCam delay is in milliseconds
      if capture_delay.positive?
        " /delay #{capture_delay * 1000}"
      else
        # DirectShow takes a while to show, default to 3 sec delay
        ' /delay 3000'
      end
    end

    def executable_path
      File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'CommandCam', 'CommandCam.exe')
    end
  end
end
