if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.at_exit do
    SimpleCov.result.format!
    `open ./coverage/index.html` if RUBY_PLATFORM =~ /darwin/
  end
end

require 'lolcommits'
require 'minitest/autorun'
