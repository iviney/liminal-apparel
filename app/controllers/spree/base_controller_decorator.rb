Spree::BaseController.class_eval do
  include ActiveCountryHelper

  before_filter :set_currency
  
  private
    def set_currency
      Site.active_currency = nil
      
      # In the admin area we do not want an active currency!
      unless self.class.name.starts_with?("Admin::")
        if new_zealand?
          Site.active_currency = "NZD" 
        elsif australia?
          Site.active_currency = "AUD"
        end
      end
    end
end
