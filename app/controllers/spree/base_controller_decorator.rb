Spree::BaseController.class_eval do
  include ActiveCountryHelper
  
  before_filter :set_currency
  
  private
    def set_currency
      # In the admin area we do not want an active currency
      if self.class.name.starts_with?("Admin::")
        Site.active_currency = nil
      else
        Site.active_currency = (australia? ? "AUD" : "NZD")
      end
    end
end
