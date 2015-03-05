# -*- encoding : utf-8 -*-
require 'fileutils'
require 'aruba/api'

Given(/^I am in a directory named "(.*?)"$/) do |dir_name|
  steps %Q{
    Given a directory named "#{dir_name}"
    And I cd to "#{dir_name}"
  }
end

Given(/^a git repo named "(.*?)"$/) do |repo_name|
  steps %Q{
   Given I successfully run `git init --quiet "#{repo_name}"`
  }
end

Given(/^the git repo named "(.*?)" has no "(.*?)" hook$/) do |repo, hook_name|
  hook_file = File.join current_dir, repo, '.git', 'hooks', hook_name
  FileUtils.delete(hook_file) if File.exists? hook_file
end

Given(/^the git repo named "(.*?)" has a "(.*?)" hook$/) do |repo, hook_name|
  hook_file = File.join current_dir, repo, '.git', 'hooks', hook_name
  FileUtils.touch(hook_file) if not File.exists? hook_file
end

Given(/^the "(.*?)" repo "(.*?)" hook has content "(.*?)"$/) do |repo, hook_name, hook_content|
  step %{the git repo named "#{repo}" has a "#{hook_name}" hook}
  hook_file = File.join current_dir, repo, '.git', 'hooks', hook_name
  File.open(hook_file, 'w') { |f| f.write(hook_content) }
end

Given(/^a git repo named "(.*?)" with (a|no) "(.*?)" hook$/) do |repo, yesno_modifier, hook_name|
  steps %Q{
    Given a git repo named "#{repo}"
    And the git repo named "#{repo}" has #{yesno_modifier} "#{hook_name}" hook
  }
end

Given(/^I am in a git repo named "(.*?)"$/) do |repo|
  steps %Q{
    Given a git repo named "#{repo}"
    And I cd to "#{repo}"
  }
end

Given(/^I am in a git repo named "(.*?)" with lolcommits enabled$/) do |repo|
  steps %Q{
    Given I am in a git repo named "#{repo}"
    And I successfully run `lolcommits --enable`
  }
end

Given(/^I have environment variable (.*?) set to (.*?)$/) do |var, value|
  set_env var, value
end

When(/^I run `(.*?)` and wait for output$/) do |command|
  command = "cd #{current_dir} && #{command}"
  @stdin, @stdout, @stderr = Open3.popen3(command)
  @fields = {}
end

Given(/^a loldir named "(.*?)" with (\d+) lolimages$/) do |repo, num_images|
  loldir = "tmp/aruba/.lolcommits/#{repo}"
  FileUtils.mkdir_p loldir
  num_images.to_i.times do
    random_hex = '%011x' % (rand * 0xfffffffffff)
    cp 'test/images/test_image.jpg', File.join(loldir, "#{random_hex}.jpg")
  end
end

Then(/^there should be (?:exactly|only) (.*?) (jpg|gif|pid)(?:s?) in "(.*?)"$/) do |n, type, folder|
  expect(n.to_i).to eq(Dir["#{current_dir}/#{folder}/*.#{type}"].count)
end

Then(/^the output should contain a list of plugins$/) do
  step %{the output should contain "Available plugins: "}
end

When(/^I do a git commit with commit message "(.*?)"$/) do |commit_msg|
  filename = Faker::Lorem.words(1).first
  steps %Q{
    Given a 98 byte file named "#{filename}"
    And I successfully run `git add #{filename}`
    And I successfully run `git commit -m "#{commit_msg}"`
  }
end

When(/^I do a git commit$/) do
  step %{I do a git commit with commit message "#{Faker::Lorem.sentence}"}
end

When(/^I do (\d+) git commits$/) do |n|
  n.to_i.times do
    step %{I do a git commit}
    sleep 0.1
  end
end

Then(/^there should be (\d+) commit entries in the git log$/) do |n|
  sleep 1 # let the file writing catch up
  expect(n.to_i).to eq `git shortlog | grep -E '^[ ]+\w+' | wc -l`.chomp.to_i
end

Given(/^I am using a "(.*?)" platform$/) do |platform_name|
  set_env 'LOLCOMMITS_FAKEPLATFORM', platform_name
end

When(/^I wait for the child process to exit in "(.*?)"$/) do |repo_name|
  sleep 0.1 while File.exist?("tmp/aruba/.lolcommits/#{repo_name}/lolcommits.pid")
end
