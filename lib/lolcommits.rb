# -*- encoding : utf-8 -*-
$LOAD_PATH.unshift File.expand_path('.')

require 'core_ext/class'
require 'mini_magick'
require 'core_ext/mini_magick/utilities'
require 'fileutils'
require 'git'
require 'open3'
require 'methadone'
require 'date'
require 'mercurial-ruby'
require 'core_ext/mercurial-ruby/shell'

require 'lolcommits/version'
require 'lolcommits/configuration'
require 'lolcommits/capturer'
require 'lolcommits/vcs_info'
require 'lolcommits/installation'
require 'lolcommits/plugin'
require 'lolcommits/platform'

# after lolcommits/platform, so that we can do platform-conditional override
require 'core_ext/mercurial-ruby/command'

# backends
require 'lolcommits/backends/installation_git'
require 'lolcommits/backends/installation_mercurial'
require 'lolcommits/backends/git_info'
require 'lolcommits/backends/mercurial_info'

require 'lolcommits/plugins/loltext'
require 'lolcommits/plugins/dot_com'
require 'lolcommits/plugins/tranzlate'
require 'lolcommits/plugins/lol_twitter'
require 'lolcommits/plugins/uploldz'
require 'lolcommits/plugins/lolsrv'
require 'lolcommits/plugins/lol_yammer'
require 'lolcommits/plugins/lol_protonet'
require 'lolcommits/plugins/lol_tumblr'
require 'lolcommits/plugins/lol_slack'

# require runner after all the plugins have been required
require 'lolcommits/runner'
