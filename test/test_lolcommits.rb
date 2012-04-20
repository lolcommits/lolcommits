require 'test/unit'

begin
  require 'lolcommits'
rescue LoadError
  require 'rubygems'
  require 'lolcommits'
end

include Lolcommits

class LolTest < Test::Unit::TestCase
    def test_can_parse_git
        assert_nothing_raised do
            Lolcommits.parse_git()
        end
    end
end
