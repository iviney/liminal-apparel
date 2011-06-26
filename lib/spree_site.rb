require "liminal_hooks"
require "active_record/remove_validator"

module SpreeSite
  class Engine < Rails::Engine
    def self.activate
      # Add your custom site logic here
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end
    config.to_prepare &method(:activate).to_proc
    
    #
    # Spree v0.50.0 causes application rake tasks to be run twice, a fix has been committed but has not yet been
    # officially released, so backport for now. This can be removed when next upgrading Spree.
    #
    #   http://railsdog.lighthouseapp.com/projects/31096/tickets/1792-spree-causes-rake-tasks-to-be-invoked-twice
    #   https://github.com/spree/spree/commit/fb5490157dfe3cd4d7da6e20a0fe61065b097639
    #
    def load_tasks
    end
  end
end
