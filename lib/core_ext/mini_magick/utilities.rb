# To maintain MiniMagick compatibility on Windows for v3.8.1 we need this patch
# If/when we upgrade MiniMagick to 4.2+ this patch can be removed
# We are locked at v3.8.1 since MiniMagick 4+ dropped support for Ruby 1.8.7
module MiniMagick
  module Utilities
    class << self
      # fixes issue introduced in this commit
      # https://github.com/minimagick/minimagick/commit/65b6427395cbfe6
      def windows_escape(cmdline)
        '"' + cmdline.gsub(/\\(?=\\*\")/, '\\\\\\').gsub(/\"/, '\\"').gsub(/\\$/, '\\\\\\').gsub('%', '%%') + '"'
      end
    end
  end
end
