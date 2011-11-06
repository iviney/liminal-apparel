# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# Email crash reports
LiminalApparel::Application.config.middleware.use ExceptionNotifier,
  :email_prefix => "[Liminal Apparel] ",
  :sender_address => %{"Crash notifier" <notifier@liminal.org.nz>},
  :exception_recipients => %w{ian.viney@gmail.com}


run LiminalApparel::Application
