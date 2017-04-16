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
  def test_lol_twitter_build_tweet
    # issue #136, https://github.com/mroth/lolcommits/issues/136
    long_commit_message = FFaker::Lorem.sentence(500)
    plugin              = Lolcommits::Plugin::LolTwitter.new(nil)
    max_tweet_size      = 116
    suffix              = '... #lolcommits'

    Lolcommits::Plugin::LolTwitter.send(:define_method, :max_tweet_size, proc { max_tweet_size })
    Lolcommits::Plugin::LolTwitter.send(:define_method, :configuration, proc { {} })
    assert_equal "#{long_commit_message[0..(max_tweet_size - suffix.length)]}#{suffix}", plugin.build_tweet(long_commit_message)
  end

  def test_lol_twitter_prefix_suffix
    plugin = Lolcommits::Plugin::LolTwitter.new(nil)
    Lolcommits::Plugin::LolTwitter.send(:define_method, :max_tweet_size, proc { 116 })
    assert_match 'commit msg #lolcommits', plugin.build_tweet('commit msg')

    plugin_config = {
      'prefix' => '@prefixing!',
      'suffix' => '#suffixing!'
    }
    Lolcommits::Plugin::LolTwitter.send(:define_method, :configuration, proc { plugin_config })
    assert_equal '@prefixing! commit msg #suffixing!', plugin.build_tweet('commit msg')
  end
end
