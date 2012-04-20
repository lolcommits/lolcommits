require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  #t.libs << 'test'
  t.test_files = Dir.glob('test/test_*.rb')
end

desc "Run tests"
task :default => :test

desc "Migrate an existing local .lolcommits directory to Dropbox"
task :dropboxify do
  dropbox_loldir = "#{$home}/Dropbox/lolcommits"
  loldir = "#{$home}/.lolcommits"
  backup_loldir = "#{$home}/.lolcommits.old"
  
  #check whether we've done this already
  if File.symlink? loldir
    abort "already dropboxified!"
  end
  
  #create dropbox folder
  if not File.directory? dropbox_loldir
    FileUtils.mkdir_p dropbox_loldir
  end
  
  #backup existing loldir
  if File.directory? loldir
    FileUtils.mv( loldir, backup_loldir )
  end
  
  #symlink dropbox to local
  FileUtils.ln_s( dropbox_loldir, loldir )
  
  #copy over existing files
  FileUtils.cp_r( "#{backup_loldir}/.", loldir)
end
