include FileUtils


Given /^a git repository named "(.*?)"$/ do |repo_name|
  repo_dir = File.join current_dir, repo_name
  mkdir_p repo_dir
  Dir.chdir repo_dir do
    sh "git init ."
  end
end

Given /^the git repository named "(.*?)" has no "(.*?)" hook$/ do |repo_name, hook_name|
  hook_file = File.join current_dir, repo_name, ".git", "hooks", hook_name
  delete(hook_file) if File.exists? hook_file
end

Given /^the git repository named "(.*?)" has a "(.*?)" hook$/ do |repo_name, hook_name|
  hook_file = File.join current_dir, repo_name, ".git", "hooks", hook_name
  touch(hook_file) if not File.exists? hook_file
end

When /^I run `(.*?)` and wait for output$/ do |command|
  command = "cd #{current_dir} && #{command}"
  @stdin, @stdout, @stderr = Open3.popen3(command)
  @fields = Hash.new
end

Then /^I should be (prompted for|presented) "(.*?)"$/ do |_, prompt|
  assert @stdout.read.to_s.include?(prompt)
end

When /^I enter "(.*?)" for "(.*?)"$/ do |input, field|
  @fields[field] = input
  @stdin.puts input
end


Then /^there should be (.*?) jpg(|s) in "(.*?)"$/ do |n, _, folder|
  assert_equal n.to_i, Dir["#{current_dir}/#{folder}/*.jpg"].count
end
