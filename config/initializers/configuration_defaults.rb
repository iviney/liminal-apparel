# Overrides some of the Spree gem defaults in app/models/app_configuration.rb

if Spree::Config.instance # check if we're not really running, e.g. when doing a rake task.
  Spree::Config.set :site_name => 'Liminal Apparel Store'
  Spree::Config.set :default_country_id => 145 # New Zealand (see numbers in db/default/countries.yml)
  Spree::Config.set :logo => "/images/liminal-apparel.jpg"
  Spree::Config.set :checkout_zone => 'Liminal Sales Zone'
  Spree::Config.set :required_currencies => "NZD"
  Spree::Config.set :address_requires_state => false
  Spree::Config.set :admin_products_per_page => 50
  Spree::Config.set :products_per_page => 12 # for bags
  Spree::Config.set :allow_backorder_shipping => true
  Spree::Config.set :track_inventory_levels => false # will not track on_hand values for variants /products
end