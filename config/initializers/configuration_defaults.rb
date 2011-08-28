# Overrides some of the Spree gem defaults in app/models/app_configuration.rb

Spree::Config.set(:site_name => 'Liminal Apparel Store')
Spree::Config.set(:site_url => 'test.store.liminal.org.nz') # TBD can perhaps use request.host or SERVER_ADDRESS?
Spree::Config.set :default_country_id => 145 # New Zealand (see numbers in db/default/countries.yml)
#Spree::Config.set :admin_interface_logo=> 'admin/bg/spree_50.png' # TBD: change this
Spree::Config.set :checkout_zone => 'Liminal Sales Zone'
Spree::Config.set :required_currencies => "NZD AUD"
Spree::Config.set :address_requires_state => false