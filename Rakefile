require 'bundler'
require 'rake/clean'

require 'rake/testtask'

require 'cucumber'
require 'cucumber/rake/task'
gem 'rdoc' # we need the installed RDoc gem, not the system one
require 'rdoc/task'

include Rake::DSL

Bundler::GemHelper.install_tasks

task :fix_permissions do
  # Reset all permissions.
  system 'bash -c "find . -type f -exec chmod 644 {} \; && find . -type d -exec chmod 755 {} \;"'
  # Executable files.
  system 'bash -c "chmod +x ./bin/* vendor/ext/imagesnap/imagesnap"'
end

Rake::Task[:build].prerequisites.unshift :fix_permissions

Rake::TestTask.new do |t|
  t.pattern = 'test/test_*.rb'
end

Rake::FileUtilsExt.verbose(false)
CUKE_RESULTS = 'results.html'
CLEAN << CUKE_RESULTS
Cucumber::Rake::Task.new(:features) do |t|
  optstr = "features --format html -o #{CUKE_RESULTS} --format Fivemat -x"
  optstr << " --tags @#{ENV["tag"]}" unless ENV["tag"].nil?
  optstr << " --tags ~@unstable" if ENV["tag"].nil? #ignore unstable tests unless specifying something at CLI
  t.cucumber_opts = optstr
  t.fork = false
end

Rake::RDocTask.new do |rd|
  
  rd.main = "README.rdoc"
  
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
end

task :default => [:test,:features]



desc "Migrate an existing local .lolcommits directory to Dropbox"
task :dropboxify do
  $home = ENV['HOME']
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
