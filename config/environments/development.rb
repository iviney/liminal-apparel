LiminalApparel::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true
  config.log_level = :info # :warn # required to stop Ruby crashing under Windows when more verbose log levels are used
  # - see https://rails.lighthouseapp.com/projects/8994/tickets/5590 and
  #       http://redmine.ruby-lang.org/issues/show/3840

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.smtp_settings = { :address => "smtp.clear.net.nz" }

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  Site.domains = {
    :new_zealand => "dev.liminal.org.nz",
    :australia => "dev.liminal.org.au"
  }
  
  # In development, all domains should resolve to localhost
  require "resolv"
  Site.domains.values.each do |domain|
    address = Resolv.getaddress(domain) rescue nil
    unless address == "127.0.0.1"
      puts "[WARNING] #{domain} does not resolve to 127.0.0.1. Please add it to /etc/hosts"
    end
  end
end
