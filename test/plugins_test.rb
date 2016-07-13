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

class PluginsTest < MiniTest::Test
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
    long_commit_message = FFaker::Lorem.sentence(500)
    plugin              = Lolcommits::LolTwitter.new(nil)
    max_tweet_size      = 116
    suffix              = '... #lolcommits'

    Lolcommits::LolTwitter.send(:define_method, :max_tweet_size, proc { max_tweet_size })
    Lolcommits::LolTwitter.send(:define_method, :configuration, proc { {} })
    assert_equal "#{long_commit_message[0..(max_tweet_size - suffix.length)]}#{suffix}", plugin.build_tweet(long_commit_message)
  end

  def test_lol_twitter_prefix_suffix
    plugin = Lolcommits::LolTwitter.new(nil)
    Lolcommits::LolTwitter.send(:define_method, :max_tweet_size, proc { 116 })
    assert_match 'commit msg #lolcommits', plugin.build_tweet('commit msg')

    plugin_config = {
      'prefix' => '@prefixing!',
      'suffix' => '#suffixing!'
    }
    Lolcommits::LolTwitter.send(:define_method, :configuration, proc { plugin_config })
    assert_equal '@prefixing! commit msg #suffixing!', plugin.build_tweet('commit msg')
  end
end
