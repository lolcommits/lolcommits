# -*- encoding : utf-8 -*-
require 'fileutils'
require 'aruba/api'

def postcommit_hook
  ".git/hooks/post-commit"
end

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

Given(/^I am in a git repo named "(.*?)"$/) do |repo|
  steps %Q{
    Given a git repo named "#{repo}"
    And I cd to "#{repo}"
  }
end

Given(/^I am in a git repo$/) do
  steps %Q{
    Given I am in a git repo named "standard"
  }
end

Given(/^I am in a git repo named "(.*?)" with lolcommits enabled$/) do |repo|
  steps %Q{
    Given I am in a git repo named "#{repo}"
    And I successfully run `lolcommits --enable`
  }
end

Given(/^I am in a git repo with lolcommits enabled$/) do
  steps %Q{
    Given I am in a git repo named "standard" with lolcommits enabled
  }
end

Given(/^a post\-commit hook with "(.*?)"$/) do |file_content|
  steps %Q{
    Given a file named "#{postcommit_hook}" with:
      """
      #{file_content}
      """
  }
end

Then(/^the lolcommits post\-commit hook should be properly installed$/) do
  steps %Q{
    Then the post-commit hook should contain "lolcommits --capture"
  }
end

Then(/^the post\-commit hook (should|should not) contain "(.*?)"$/) do |should, content|
  steps %Q{
    Then the file "#{postcommit_hook}" #{should} contain "#{content}"
  }
end

Given(/^I have environment variable (.*?) set to (.*?)$/) do |var, value|
  set_env var, value
end

Given(/^a loldir named "(.*?)" with (\d+) lolimages$/) do |repo, num_images|
  loldir = absolute_path("~/.lolcommits/#{repo}")
  FileUtils.mkdir_p loldir
  num_images.to_i.times do
    hex = '%011x' % (rand * 0xfffffffffff)
    FileUtils.cp 'test/images/test_image.jpg', File.join(loldir, "#{hex}.jpg")
  end
end

Then(/^there should be (?:exactly|only) (.*?) (jpg|gif|pid)(?:s?) in "(.*?)"$/) do |n, type, folder|
  expect(Dir[absolute_path(folder, "*.#{type}")].count).to eq(n.to_i)
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
  pid_loc = absolute_path("~/.lolcommits/#{repo_name}/lolcommits.pid")
  sleep 0.1 while File.exist?(pid_loc)
end
