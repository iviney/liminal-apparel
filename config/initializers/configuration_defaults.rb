# Overrides some of the Spree gem defaults in app/models/app_configuration.rb

Spree::Config.set :site_name => 'Liminal Apparel Store'
Spree::Config.set :default_country_id => 145 # New Zealand (see numbers in db/default/countries.yml)
Spree::Config.set :logo => "/images/liminal-apparel.jpg"
Spree::Config.set :checkout_zone => 'Liminal Sales Zone'
Spree::Config.set :required_currencies => "NZD AUD"
Spree::Config.set :address_requires_state => false