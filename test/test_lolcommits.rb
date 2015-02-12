# -*- encoding : utf-8 -*-
require 'coveralls'
Coveralls.wear!

require 'minitest/autorun'
require 'ffaker'

# Loads lolcommits directly from the lib folder so don't have to create
# a gem before testing
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lolcommits'

include Lolcommits

class LolTest < MiniTest::Test
  #
  # issue #57, https://github.com/mroth/lolcommits/issues/57
  #
  def test_tranzlate
    [['what the hell', '(WH|W)UT TEH HELL'], ['seriously wtf', 'SRSLEH WTF']].each do |normal, lol|
      tranzlated = Lolcommits::Tranzlate.tranzlate(normal)
      assert_match(/^#{lol}/, tranzlated)
    end
  end

  #
  # issue #136, https://github.com/mroth/lolcommits/issues/136
  def test_lol_twitter_build_tweet
    long_commit_message = Faker::Lorem.sentence(500)
    plugin              = Lolcommits::LolTwitter.new(nil)
    max_tweet_size      = 116
    suffix              = '... #lolcommits'

    Lolcommits::LolTwitter.send(:define_method, :max_tweet_size, Proc.new { max_tweet_size })
    assert_match "#{long_commit_message[0..(max_tweet_size - suffix.length)]}#{suffix}", plugin.build_tweet(long_commit_message)
  end

  def test_lol_twitter_prefix_suffix
    plugin = Lolcommits::LolTwitter.new(nil)
    Lolcommits::LolTwitter.send(:define_method, :max_tweet_size, Proc.new { 116 })
    assert_match 'commit msg #lolcommits', plugin.build_tweet('commit msg')

    plugin_config = {
      'prefix' => '@prefixing!',
      'suffix' => '#suffixing!'
    }
    Lolcommits::LolTwitter.send(:define_method, :configuration, Proc.new { plugin_config })
    assert_match '@prefixing! commit msg #suffixing!', plugin.build_tweet('commit msg')
  end

  #
  # issue #53, https://github.com/mroth/lolcommits/issues/53
  # this will test the permissions but only locally, important before building a gem package!
  #
  def test_permissions
    impact_perms     = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'fonts', 'Impact.ttf')).mode & 0777
    imagesnap_perms  = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'imagesnap', 'imagesnap')).mode & 0777
    videosnap_perms  = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'videosnap', 'videosnap')).mode & 0777
    commandcam_perms = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, 'vendor', 'ext', 'CommandCam', 'CommandCam.exe')).mode & 0777

    assert impact_perms == 0644 || impact_perms == 0664,
           "expected perms of 644/664 but instead got #{sprintf '%o', impact_perms}"
    assert imagesnap_perms == 0755 || imagesnap_perms == 0775,
           "expected perms of 755/775 but instead got #{sprintf '%o', imagesnap_perms}"
    assert videosnap_perms == 0755 || videosnap_perms == 0775,
           "expected perms of 755/775 but instead got #{sprintf '%o', videosnap_perms}"
    assert commandcam_perms == 0755 || commandcam_perms == 0775,
           "expected perms of 755/775 but instead got #{sprintf '%o', commandcam_perms}"
  end
end
