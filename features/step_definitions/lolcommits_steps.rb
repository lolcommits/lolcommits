require 'fileutils'
require 'aruba/api'

def postcommit_hook_git
  '.git/hooks/post-commit'
end

def postcommit_hook_mercurial
  '.hg/hgrc'
end

def default_repo
  'myrepo'
end

def default_loldir
  "~/.lolcommits/#{default_repo}"
end

Given(/^I am in a directory named "(.*?)"$/) do |dir_name|
  steps %(
    Given a directory named "#{dir_name}"
    And I cd to "#{dir_name}"
    )
end

Given(/^a git repo named "(.*?)"$/) do |repo_name|
  steps %(
   Given I run `git init --quiet "#{repo_name}"`
    )
end

Given(/^I am in a git repo named "(.*?)"$/) do |repo|
  steps %(
    Given a git repo named "#{repo}"
    And I cd to "#{repo}"
    )
end

Given(/^I am in a git repo$/) do
  steps %(
    Given I am in a git repo named "#{default_repo}"
    )
end

Given(/^I am not in a git repo/) do
  steps %(
    Given I cd to "/tmp"
    And a directory named "lolcommits_no_repo"
    And I cd to "lolcommits_no_repo"
    )
end

Given(/^I am in a git repo named "(.*?)" with lolcommits enabled$/) do |repo|
  steps %(
    Given I am in a git repo named "#{repo}"
    And I run `lolcommits --enable`
    )
end

Given(/^I am in a git repo with lolcommits enabled$/) do
  steps %(
    Given I am in a git repo named "#{default_repo}" with lolcommits enabled
    )
end

Given(/^a git post-commit hook with "(.*?)"$/) do |file_content|
  steps %(
    Given a file named "#{postcommit_hook_git}" with:
      """
      #{file_content}
      """
    )
end

Then(/^the lolcommits git post-commit hook should be properly installed$/) do
  steps %(
    Then the git post-commit hook should contain "lolcommits --capture"
    )
end

Then(/^the git post-commit hook (should|should not) contain "(.*?)"$/) do |should, content|
  steps %(
    Then the file "#{postcommit_hook_git}" #{should} contain "#{content}"
    )
end

Given(/^a mercurial repo named "(.*?)"$/) do |repo_name|
  steps %(
   Given I run `hg init "#{repo_name}"`
    )
end

Given(/^I am in a mercurial repo named "(.*?)"$/) do |repo|
  steps %(
    Given a mercurial repo named "#{repo}"
    And I cd to "#{repo}"
    )
end

Given(/^I am in a mercurial repo$/) do
  steps %(
    Given I am in a mercurial repo named "#{default_repo}"
    )
end

Given(/^I am in a mercurial repo named "(.*?)" with lolcommits enabled$/) do |repo|
  steps %(
    Given I am in a mercurial repo named "#{repo}"
    And I run `lolcommits --enable`
    )
end

Given(/^I am in a mercurial repo with lolcommits enabled$/) do
  steps %(
    Given I am in a mercurial repo named "#{default_repo}" with lolcommits enabled
    )
end

Given(/^a mercurial post-commit hook with "(.*?)"$/) do |file_content|
  steps %(
    Given a file named "#{postcommit_hook_mercurial}" with:
      """
      #{file_content}
      """
    )
end

Then(/^the lolcommits mercurial post-commit hook should be properly installed$/) do
  steps %(
    Then the mercurial post-commit hook should contain "lolcommits --capture"
    )
end

Then(/^the mercurial post-commit hook (should|should not) contain "(.*?)"$/) do |should, content|
  steps %(
    Then the file "#{postcommit_hook_mercurial}" #{should} contain "#{content}"
    )
end

Given(/^I have environment variable (.*?) set to (.*?)$/) do |var, value|
  set_environment_variable var, value
end

Given(/^its loldir has (\d+) lolimages$/) do |num_images|
  steps %(
    Given a loldir named "#{default_repo}" with #{num_images} lolimages
    )
end

Given(/^a loldir named "(.*?)" with (\d+) lolimages$/) do |repo, num_images|
  loldir = expand_path("~/.lolcommits/#{repo}")
  FileUtils.mkdir_p loldir
  num_images.to_i.times do
    sha = format('%<hex>x', hex: (rand * 0xfffffffffff))
    FileUtils.cp 'test/assets/test_image.jpg', File.join(loldir, "#{sha}.jpg")
  end
end

Then(/^there should be exactly (.*?) (mp4|jpg|gif|pid)s? in its loldir$/) do |n, type|
  steps %(
    Then there should be exactly #{n} #{type} in "#{default_loldir}"
    )
end

Then(/^there should be exactly (.*?) (mp4|jpg|gif|pid)s? in "(.*?)"$/) do |n, type, folder|
  expect(Dir[expand_path("#{folder}/*.#{type}")].count).to eq(n.to_i)
end

Then(/^the output should contain a list of plugins$/) do
  step %(the output should contain "Installed plugins: (* enabled)")
  step %(the output should contain "[*] loltext")
end

Then(/^the output should show the version number$/) do
  step %(the output should match /^#{Lolcommits::VERSION}$/)
end

When(/^I do a git commit with commit message "(.*?)"$/) do |commit_msg|
  filename = FFaker::Lorem.words(1).first
  steps %(
    Given a 98 byte file named "#{filename}"
    And I run `git add #{filename}`
    And I run `git commit -m "#{commit_msg}"`
    )
end

When(/^I do a git commit$/) do
  step %(I do a git commit with commit message "#{FFaker::Lorem.sentence}")
end

When(/^I do (\d+) git commits$/) do |n|
  n.to_i.times do
    step %(I do a git commit)
    sleep 0.2
  end
end

Then(/^there should be (\d+) commit entries in the git log$/) do |n|
  sleep 1 # let the file writing catch up
  expect(n.to_i).to eq `git shortlog | grep -E '^[ ]+\w+' | wc -l`.chomp.to_i
end

When(/^I do a mercurial commit with commit message "(.*?)"$/) do |commit_msg|
  filename = FFaker::Lorem.words(1).first
  steps %(
    Given a 98 byte file named "#{filename}"
    And I run `hg add #{filename}`
    And I run `hg commit -m "#{commit_msg}"`
    )
end

When(/^I do a mercurial commit$/) do
  step %(I do a mercurial commit with commit message "#{FFaker::Lorem.sentence}")
end

When(/^I do (\d+) mercurial commits$/) do |n|
  n.to_i.times do
    step %(I do a mercurial commit)
    sleep 0.1
  end
end

Then(/^there should be (\d+) commit entries in the mercurial log$/) do |n|
  sleep 1 # let the file writing catch up
  expect(n.to_i).to eq `hg log | grep '^changeset:' | wc -l`.chomp.to_i
end

Given(/^I am using a "(.*?)" platform$/) do |host_os_name|
  set_environment_variable 'LOLCOMMITS_FAKE_HOST_OS', host_os_name
end

When(/^I wait for the child process to exit in "(.*?)"$/) do |repo_name|
  pid_loc = expand_path("~/.lolcommits/#{repo_name}/lolcommits.pid")
  sleep 0.1 while File.exist?(pid_loc)
end
