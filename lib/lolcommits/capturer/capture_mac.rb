# frozen_string_literal: true

module Lolcommits
  class CaptureMac < Capturer
    def capture
      system_call "#{executable_path} -q \"#{capture_path}\" -w #{capture_delay} #{capture_device_string}"
    end

    private

    def capture_device_string
      capture_device.nil? ? "" : "-d \"#{capture_device}\""
    end

    def executable_path
      File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "ext", "imagesnap", "imagesnap")
    end
  end
end
