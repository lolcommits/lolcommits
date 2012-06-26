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
            Lolcommits.parse_git()
        end
    end

    def test_tranzlate
        assert "what the hell".tranzlate.start_with? "WHUT TEH HELL"
        assert "seriously wtf".tranzlate.start_with? "SRSLEH WTF"
    end

    # Hmm.. webcam capture breaks travis-ci tests
    #def test_can_capture
    #    assert_nothing_raised do
    #        Lolcommits.capture(0,true,'test commit message','test-sha-001')
    #    end
    #end
end
