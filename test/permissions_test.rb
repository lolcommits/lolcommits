require File.expand_path(File.dirname(__FILE__) + '/test_helper')

class PermissionsTest < Minitest::Test
  #
  # issue #53, https://github.com/mroth/lolcommits/issues/53
  # this will test the permissions but only locally, important before building a gem package!
  #
  def test_permissions
    imagesnap_perms  = File.lstat(File.join(Lolcommits::Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'imagesnap', 'imagesnap')).mode & 0o777
    videosnap_perms  = File.lstat(File.join(Lolcommits::Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'videosnap', 'videosnap')).mode & 0o777
    commandcam_perms = File.lstat(File.join(Lolcommits::Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'CommandCam', 'CommandCam.exe')).mode & 0o777

    assert imagesnap_perms == 0o755 || imagesnap_perms == 0o775,
           "expected perms of 755/775 but instead got #{format '%<perms>o', perms: imagesnap_perms}"
    assert videosnap_perms == 0o755 || videosnap_perms == 0o775,
           "expected perms of 755/775 but instead got #{format '%<perms>o', perms: videosnap_perms}"
    assert commandcam_perms == 0o755 || commandcam_perms == 0o775,
           "expected perms of 755/775 but instead got #{format '%<perms>o', perms: commandcam_perms}"
  end
end
