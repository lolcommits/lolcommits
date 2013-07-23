module PathHelpers

  def reject_paths_with_cmd(cmd)
    @original_path = ENV['PATH']
    # make a new subdir that still contains cmds
    tmpbindir = File.expand_path(File.join @dirs, "bin")
    FileUtils.mkdir_p tmpbindir

    preseve_cmds_in_path(['git', 'mplayer'], tmpbindir)

    exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
    newpaths = ENV['PATH'].split(File::PATH_SEPARATOR).reject do |path|
      found_cmd = false
      exts.each { |ext|
        exe = "#{path}/#{cmd}#{ext}"
        found_cmd = true if File.executable? exe
      }
      found_cmd
    end

    # add the temporary directory with git in it back into the path
    newpaths << tmpbindir
    ENV['PATH'] = newpaths.join(File::PATH_SEPARATOR)
  end

  def preseve_cmds_in_path(cmds, tmpbindir)
    cmds.each do |cmd|
      whichcmd = Lolcommits::Configuration.command_which(cmd)
      unless whichcmd.nil?
        FileUtils.ln_s whichcmd, File.join(tmpbindir, File.basename(whichcmd))
      end
    end
  end

  def reset_path
    ENV['PATH'] = @original_path
  end

end
