# Overrides some of the Spree gem defaults in app/models/app_configuration.rb

Spree::Config.set(:site_name => 'Liminal Apparel Store')
Spree::Config.set :default_country_id => 12 # Australia (see numbers in db/default/countries.yml)
#Spree::Config.set :admin_interface_logo=> 'admin/bg/spree_50.png' # TBD: change this
Spree::Config.set :checkout_zone => 'Liminal Sales Zone'
