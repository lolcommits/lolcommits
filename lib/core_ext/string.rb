# -*- encoding : utf-8 -*-
if RUBY_VERSION =~ /^1\.8/
  class String
    # used unconditionally by mercurial-ruby
    def encode(str, _options)
      str
    end
  end
end
