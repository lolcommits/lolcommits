require 'methadone'
require 'clamp'

module Lolcommits
  module CLI

    # Lolcommits::CLI:Command just wraps Clamp::Command to include logging
    class Command < Clamp::Command
      include Methadone::CLILogging
    end

  end
end
