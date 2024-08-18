# frozen_string_literal: true

module Mercurial
  class ConfigFile
    def exists?
      # Mercurial::ConfigFile#exists? patched to be Ruby 3.2+ compatible
      File.exist?(path)
    end
  end
end
