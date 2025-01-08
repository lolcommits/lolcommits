module Lolcommits
  class CaptureCygwin < CaptureWindows
    def capture
      _stdin, stdout, _stderr = Open3.popen3("#{executable_path} /filename `cygpath -w #{capture_path}`#{delay_arg}")

      # need to read the output for something to happen
      stdout.read
    end
  end
end
