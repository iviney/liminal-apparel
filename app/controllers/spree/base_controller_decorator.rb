Spree::BaseController.class_eval do
  include ActiveCountryHelper
  
  before_filter :set_currency
  
  private
  
  def set_currency
    Site.active_currency = (australia? ? "AUD" : "NZD")
  end
end
