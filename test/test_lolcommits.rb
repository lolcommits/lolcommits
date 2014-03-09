require 'coveralls'
Coveralls.wear!

require 'test/unit'
# Loads lolcommits directly from the lib folder so don't have to create
# a gem before testing
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'lolcommits'

include Lolcommits

class LolTest < Test::Unit::TestCase
    def test_can_parse_git
      assert_nothing_raised do
        gi = GitInfo.new
        assert_not_nil gi.message
        assert_not_nil gi.sha
      end
    end

    #
    # issue #57, https://github.com/mroth/lolcommits/issues/57
    #
    def test_tranzlate
      [["what the hell","(WH|W)UT TEH HELL"],["seriously wtf", "SRSLEH WTF"]].each do |normal, lol|
        tranzlated = Lolcommits::Tranzlate.tranzlate(normal)
        assert_match /^#{lol}/, tranzlated
      end
    end

    #
    # issue #136, https://github.com/mroth/lolcommits/issues/136
    def test_lol_twitter_build_tweet
      long_commit_message = %q{I wanna run, I want to hide, I want to tear down
the walls that hold me inside. I want to reach out, and touch the flame...
Where the streets have no name.. ah ah ah.. I want to feel sunlight on my
face... I see the dust clouds disappear, without a trace... I want to take
shelter... from the poison rain...  where the streets have no name... oahhhhh
where the streets have no name... where the streets have no name }.gsub("\n", ' ')

      plugin = Lolcommits::LolTwitter.new(nil)
      Lolcommits::LolTwitter.send(:define_method, :max_tweet_size, Proc.new { 116 })
      assert_match 'I wanna run, I want to hide, I want to tear down the walls that hold me inside. I want to reach out, a... #lolcommits', plugin.build_tweet(long_commit_message)
    end

    #
    # issue #53, https://github.com/mroth/lolcommits/issues/53
    # this will test the permissions but only locally, important before building a gem package!
    #
    def test_permissions
      impact_perms = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "fonts", "Impact.ttf")).mode & 0777
      imagesnap_perms = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "ext", "imagesnap", "imagesnap")).mode & 0777
      videosnap_perms = File.lstat(File.join(Configuration::LOLCOMMITS_ROOT, "vendor", "ext", "videosnap", "videosnap")).mode & 0777
      assert impact_perms == 0644 || impact_perms == 0664,
        "expected perms of 644/664 but instead got #{sprintf '%o', impact_perms}"
      assert imagesnap_perms == 0755 || imagesnap_perms == 0775,
        "expected perms of 755/775 but instead got #{sprintf '%o', imagesnap_perms}"
      assert videosnap_perms == 0755 || videosnap_perms == 0775,
        "expected perms of 755/775 but instead got #{sprintf '%o', videosnap_perms}"
    end

    # Hmm.. webcam capture breaks travis-ci tests
    #def test_can_capture
    #  assert_nothing_raised do
    #    Lolcommits.capture(0,true,'test commit message','test-sha-001')
    #  end
    #end

end
