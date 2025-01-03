# frozen_string_literal: true

module Mercurial
  class ChangedFile
    private

    def enforce_unicode(str)
      # String#encode patched to be Ruby 3.0+ compatible
      str.encode("utf-8", invalid: :replace, undef: :replace, replace: "?")
    end
  end
end
