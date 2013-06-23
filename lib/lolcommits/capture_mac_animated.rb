module Lolcommits
  class CaptureMacAnimated < Capturer

    def capture
      # make a fresh frames directory
      FileUtils.rm_rf(frames_location)
      FileUtils.mkdir_p(frames_location)

      # capture the raw video with videosnap
      system_call "#{videosnap_bin} -s 240 #{capture_device_string}#{capture_delay_string}-t #{animated_duration} --no-audio #{video_location} > /dev/null"
      if File.exists?(video_location)
        # convert raw video to png frames with ffmpeg
        system_call "ffmpeg -v quiet -i #{video_location} -t #{animated_duration} #{frames_location}/%09d.png"
        # create the looping animated gif from frames (picks every 2nd frame with seq)
        seq_command = "seq -f #{frames_location}/%09g.png 1 2 #{Dir["#{frames_location}/*"].length}"
        # delay of 12 between every other frame, 24fps
        system_call "convert -layers OptimizeTransparency -delay 12 -loop 0 `#{seq_command}` -coalesce #{snapshot_location}"
      end
    end

    private
    def system_call(call_str)
      debug "Capturer: making system call for \n #{call_str}"
      system(call_str)
    end

    def videosnap_bin
      File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'videosnap', 'videosnap')
    end

    def capture_device_string
      "-d '#{capture_device}' " if capture_device
    end

    def capture_delay_string
      "-w '#{capture_delay}' " if capture_delay.to_i > 0
    end

  end
end
