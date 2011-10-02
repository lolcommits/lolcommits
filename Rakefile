$home = ENV['HOME']
$srcpath = File.expand_path(File.dirname( __FILE__ ))
$githooks_userdir = "#{$home}/.git_hooks"
$srcdir = "#{$home}/.githooks_src"
$target = "/usr/local/bin/git-hooks"

task :install => [:githooks_install, :imagesnap_install] do
  # check git global init.templatedir
  # if exists, die, else, create
  #token = `git config --global init.templatedir`
  
  #create user githooks if doesnt exist
  if not File.directory? $githooks_userdir
    FileUtils.mkdir_p $githooks_userdir
    FileUtils.mkdir_p "#{$githooks_userdir}/commit-msg"
    FileUtils.mkdir_p "#{$githooks_userdir}/pre-commit"
    FileUtils.mkdir_p "#{$githooks_userdir}/post-commit"
  end
  
  # symlink hook from there to this file
  FileUtils.cp( "#{$srcpath}/lolcommit.rb", "#{$githooks_userdir}/post-commit/lolcommit" )
end

desc "Install imagesnap to /usr/local/bin"
task :imagesnap_install do
  if not File.exists? "/usr/local/bin/imagesnap"
    FileUtils.cp( "#{$srcpath}/bin/imagesnap", "/usr/local/bin/imagesnap" )
    FileUtils.chmod 0755, '/usr/local/bin/imagesnap'
  end
end

desc "Clone and install git-hooks to /usr/local/bin"
task :githooks_install do
  if not File.directory? $srcdir
    #puts "*** Checking out git-hooks repository into ~/.githooks_src"
    sh "git clone git://github.com/icefox/git-hooks.git #{$srcdir}"
  end
  
  if not File.exists? $target
    #puts "*** Symlinking git-hooks script to your /usr/local/bin"
    File.symlink("#{$srcdir}/git-hooks", $target)
  end
end

desc "Remove git-hooks install"
task :githooks_uninstall do
  if File.directory? $srcdir
    #TODO: delete it
  end
  if File.symlink? $target
    #TODO: delete it
  end
end
