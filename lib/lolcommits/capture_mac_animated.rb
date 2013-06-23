module Lolcommits
  class CaptureMacAnimated < Capturer
    def capture_device_string
      @capture_device.nil? ? nil : "--video-device #{@capture_device} "
    end

    def capture
      # make a fresh frames directory
      FileUtils.rm_rf(frames_location)
      FileUtils.mkdir_p(frames_location)

      # capture the raw video with wacaw
      system_call "#{wacaw_bin} --brief --no-audio --width 320 --height 240 --video #{capture_device_string}--duration #{animated_duration} #{video_location} > /dev/null"
      # convert raw avi to png frames with ffmpeg
      system_call "ffmpeg -v quiet -i #{video_location}.avi -t #{animated_duration} #{frames_location}/%09d.png"
      # create the looping animated gif from frames (picks every 3rd frame with seq)
      seq_command = "seq -f #{frames_location}/%09g.png 1 3 #{Dir["#{frames_location}/*"].length}"
      system_call "convert -layers OptimizeTransparency -delay 9 -loop 0 `#{seq_command}` -coalesce #{snapshot_location}"
    end

    private
    def system_call(call_str)
      debug "Capturer: making system call for \n #{call_str}"
      system(call_str)
    end

    def wacaw_bin
      File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "ext", "wacaw", "wacaw")
    end
  end
end
