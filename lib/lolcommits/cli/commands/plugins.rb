require 'lolcommits/cli/command'

module Lolcommits
  module CLI

    class PluginsCommand < Command
      subcommand 'list', 'List all available plugins' do
        def execute
          Configuration.new(PluginManager.init).list_plugins
        end
      end

      subcommand 'config', 'Configure a plugin' do
        parameter 'PLUGIN', 'name of plugin to configure'
        def execute
          Configuration.new(PluginManager.init).do_configure!(plugin)
        end
      end

      subcommand 'show-config', 'show config file' do
        def execute
          puts Configuration.new(PluginManager.init)
        end
      end
    end

  end
end
