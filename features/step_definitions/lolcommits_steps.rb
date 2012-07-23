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

Given /^a git repository named "(.*?)" with (a|no) "(.*?)" hook$/ do |repo_name, yesno_modifier, hook_name|
  step %{a git repository named "#{repo_name}"}
  step %{the git repository named "#{repo_name}" has #{yesno_modifier} "#{hook_name}" hook}
end
