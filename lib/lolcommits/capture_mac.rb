module Lolcommits
  class CaptureMac < Capturer
    def capture_device_string
      @capture_device.nil? ? nil : "-d #{@capture_device}"
    end

    def capture
      system("#{imagesnap_bin} -q \"#{snapshot_location}\" -w #{capture_delay} #{capture_device_string}")
    end

    private

    def imagesnap_bin
      File.join(Configuration::LOLCOMMITS_ROOT, "ext", "imagesnap", "imagesnap")
    end
  end
end
