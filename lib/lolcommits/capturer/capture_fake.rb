# frozen_string_literal: true

module Lolcommits
  class CaptureFake < Capturer
    def capture
      FileUtils.cp test_file, capture_path
    end

    private

    def test_file
      filename = capture_duration.zero? ? 'test_image.jpg' : 'test_video.mp4'
      File.join(Configuration::LOLCOMMITS_ROOT, 'test', 'assets', filename)
    end
  end
end
