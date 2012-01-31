source 'http://rubygems.org'

gem 'rake', '0.8.7'
gem 'rails', '3.0.7'

gem 'sqlite3'

gem 'exception_notification'

# Deploy with Capistrano
gem 'capistrano'

gem 'spree', '0.50.4'

#gem 'spree-product-options', :git => 'git://github.com/stephskardal/spree-product-options'
# didn't seem to be be available for spree 0.50.

gem 'spree_simple_volume_pricing', :git => 'git://github.com/iviney/spree-simple-volume-pricing.git', :branch => 'master'

# Adds support for the Paypal Express checkout.
gem "spree_paypal_express", :git => "git://github.com/spree/spree_paypal_express.git", :ref => "4dadc4ad67d5"

gem 'spree_additional_calculators'

gem 'spree_xero', :git => 'git://github.com/iviney/spree-xero.git'

#gem 'active_reload' # Genius! (if it worked)

group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda'
end

group :test do
  gem 'factory_girl'
  gem 'faker'
end
