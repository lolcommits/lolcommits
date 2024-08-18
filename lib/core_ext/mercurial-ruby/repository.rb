# frozen_string_literal: true

module Mercurial
  class Repository
    def self.open(destination)
      # Mercurial::Repository.open patched to be Ruby 3.2+ compatible
      raise Mercurial::RepositoryNotFound, destination unless File.exist?(destination)

      new(destination)
    end
  end
end
