# windows command line doesn't like single quotes
module Mercurial
  class Shell
    def self.interpolate_arguments(cmd_with_args)
      cmd_with_args.shift.tap do |cmd|
        cmd.gsub!(/\?/) do
          if Lolcommits::Platform.platform_windows?
            "\"#{cmd_with_args.shift}\""
          else
            cmd_with_args.shift.to_s.enclose_in_single_quotes
          end
        end
      end
    end
  end
end
