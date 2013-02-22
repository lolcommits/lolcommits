module Lolcommits
  class CaptureMac < Capturer
    def capture_device_string
      @capture_device.nil? ? nil : "-d \"#{@capture_device}\""
    end

    def capture
      call_str = "#{imagesnap_bin} -q \"#{snapshot_location}\" -w #{capture_delay} #{capture_device_string}"
      debug "Capturer: making system call for #{call_str}"
      system(call_str)
    end

    private

    def imagesnap_bin
      File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "ext", "imagesnap", "imagesnap")
    end
  end
end
