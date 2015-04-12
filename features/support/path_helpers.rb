# -*- encoding : utf-8 -*-
require 'fileutils'
require 'aruba/api'
require 'lolcommits/platform'

module PathHelpers
  def reject_paths_with_cmd(cmd)
    # make a new subdir that still contains cmds
    tmpbindir = File.expand_path(File.join @dirs, 'bin')
    FileUtils.mkdir_p tmpbindir

    preseve_cmds_in_path(%w(git mplayer), tmpbindir)

    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    newpaths = ENV['PATH'].split(File::PATH_SEPARATOR).reject do |path|
      found_cmd = false
      exts.each do |ext|
        exe = "#{path}/#{cmd}#{ext}"
        found_cmd = true if File.executable? exe
      end
      found_cmd
    end

    # add the temporary directory with git in it back into the path
    newpaths << tmpbindir

    # use aruba/api set_env to set PATH, which will be automaticaly restored
    set_env 'PATH', newpaths.join(File::PATH_SEPARATOR)
  end

  def preseve_cmds_in_path(cmds, tmpbindir)
    cmds.each do |cmd|
      whichcmd = Lolcommits::Platform.command_which(cmd)
      unless whichcmd.nil?
        FileUtils.ln_s whichcmd, File.join(tmpbindir, File.basename(whichcmd))
      end
    end
  end
end
