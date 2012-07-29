module Lolcommits
  class CaptureFake < Capturer
    def capture
      test_image = File.join Configuration::LOLCOMMITS_ROOT, "test", "images", "test_image.jpg"
      FileUtils.cp test_image, snapshot_location
    end

  end
end

