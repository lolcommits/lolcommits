# frozen_string_literal: true

module Lolcommits
  class CaptureMacAnimated < Capturer
    def capture
      system_call "#{executable_path} -p 640x480 #{capture_device_string}#{capture_delay_string}-t #{capture_duration} --no-audio \"#{capture_path}\" > /dev/null"
    end

    private

    def capture_device_string
      "-d \"#{capture_device}\" " if capture_device
    end

    def capture_delay_string
      "-w \"#{capture_delay}\" " if capture_delay.to_i > 0
    end

    def executable_path
      File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'videosnap', 'videosnap')
    end
  end
end
