module Lolcommits
  class CaptureMacAnimated < Capturer
    def capture
      # make a fresh frames directory
      FileUtils.rm_rf(frames_location)
      FileUtils.mkdir_p(frames_location)

      # capture the raw video with videosnap
      system_call "#{executable_path} -p 640x480 #{capture_device_string}#{capture_delay_string}-t #{animated_duration} --no-audio \"#{video_location}\" > /dev/null"
    end

    def executable_path
      File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'videosnap', 'videosnap')
    end

    private

    def system_call(call_str, capture_output = false)
      debug "Capturer: making system call for \n #{call_str}"
      capture_output ? `#{call_str}` : system(call_str)
    end

    def capture_device_string
      "-d \"#{capture_device}\" " if capture_device
    end

    def capture_delay_string
      "-w \"#{capture_delay}\" " if capture_delay.to_i > 0
    end
  end
end
