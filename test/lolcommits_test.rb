# -*- encoding : utf-8 -*-
require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'

# Loads lolcommits directly from the lib folder so don't have to create
# a gem before testing
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lolcommits'

include Lolcommits
include Methadone::CLILogging

class LolTest < MiniTest::Test
  #
  # issue #53, https://github.com/mroth/lolcommits/issues/53
  # this will test the permissions but only locally, important before building a gem package!
  #
  def test_permissions
    impact_perms     = File.lstat(Lolcommits::Loltext::DEFAULT_FONT_PATH).mode & 0o777
    imagesnap_perms  = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'imagesnap', 'imagesnap')).mode & 0o777
    videosnap_perms  = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'videosnap', 'videosnap')).mode & 0o777
    commandcam_perms = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'CommandCam', 'CommandCam.exe')).mode & 0o777

    assert impact_perms == 0o644 || impact_perms == 0o664,
           "expected perms of 644/664 but instead got #{format '%o', impact_perms}"
    assert imagesnap_perms == 0o755 || imagesnap_perms == 0o775,
           "expected perms of 755/775 but instead got #{format '%o', imagesnap_perms}"
    assert videosnap_perms == 0o755 || videosnap_perms == 0o775,
           "expected perms of 755/775 but instead got #{format '%o', videosnap_perms}"
    assert commandcam_perms == 0o755 || commandcam_perms == 0o775,
           "expected perms of 755/775 but instead got #{format '%o', commandcam_perms}"
  end
end
