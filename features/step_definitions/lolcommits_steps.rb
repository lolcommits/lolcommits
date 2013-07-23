include FileUtils

Given /^I am in a directory named "(.*?)"$/ do |dir_name|
  steps %Q{
    Given a directory named "#{dir_name}"
    And I cd to "#{dir_name}"
  }
end

Given /^a git repository named "(.*?)"$/ do |repo_name|
  repo_dir = File.join current_dir, repo_name
  mkdir_p repo_dir
  Dir.chdir repo_dir do
    system "git init --quiet ."
    system "git config user.name 'Testy McTesterson'"
    system "git config user.email 'testy@tester.com'"
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

Given /^I am in a git repository named "(.*?)"$/ do |repo_name|
  steps %Q{
    Given a git repository named "#{repo_name}"
    And I cd to "#{repo_name}"
  }
end

Given /^I am in a git repository named "(.*?)" with lolcommits enabled$/ do |repo_name|
  steps %Q{
    Given I am in a git repository named "#{repo_name}"
    And I successfully run `lolcommits --enable`
  }
end

When /^I run `(.*?)` and wait for output$/ do |command|
  command = "cd #{current_dir} && #{command}"
  @stdin, @stdout, @stderr = Open3.popen3(command)
  @fields = Hash.new
end

Given /^a loldir named "(.*?)" with (\d+) lolimages$/ do |repo_name, num_images|
  loldir = "tmp/aruba/.lolcommits/#{repo_name}"
  mkdir_p loldir
  num_images.to_i.times do
    random_hex = "%011x" % (rand * 0xfffffffffff)
    cp "test/images/test_image.jpg", File.join( loldir, "#{random_hex}.jpg")
  end
end

Then /^I should be (prompted for|presented) "(.*?)"$/ do |_, prompt|
  assert @stdout.read.to_s.include?(prompt)
end

When /^I enter "(.*?)" for "(.*?)"$/ do |input, field|
  @fields[field] = input
  @stdin.puts input
end

Then /^there should be (?:exactly|only) (.*?) (jpg|gif|pid)(?:s?) in "(.*?)"$/ do |n, type, folder|
  assert_equal n.to_i, Dir["#{current_dir}/#{folder}/*.#{type}"].count
end

Then /^the output should contain a list of plugins$/ do
  step %{the output should contain "Available plugins: "}
end

When /^I do a git commit with commit message "(.*?)"$/ do |commit_msg|
  filename = Faker::Lorem.words(1).first
  step %{a 98 byte file named "#{filename}"}
  step %{I successfully run `git add #{filename}`}
  step %{I successfully run `git commit -m "#{commit_msg}"`}
end

When /^I do a git commit$/ do
  commit_msg = Faker::Lorem.sentence
  step %{I do a git commit with commit message "#{commit_msg}"}
end

When /^I do (\d+) git commits$/ do |n|
  n.to_i.times do
    step %{I do a git commit}
    sleep 0.1
  end
end

Then /^there should be (\d+) commit entries in the git log$/ do |n|
  sleep 1 #let the file writing catch up
  assert_equal n.to_i, `git shortlog | grep -E '^[ ]+\w+' | wc -l`.chomp.to_i
end

Given /^I am using a "(.*?)" platform$/ do |platform_name|
  ENV['LOLCOMMITS_FAKEPLATFORM'] = platform_name
end

When /^I wait for the child process to exit in "(.*?)"$/ do |repo_name|
  while File.exist?("tmp/aruba/.lolcommits/#{repo_name}/lolcommits.pid")
    sleep 0.1
  end
end
