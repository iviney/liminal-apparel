Spree::BaseController.class_eval do
  include ActiveCountryHelper
  
  before_filter :set_currency
  
  def set_currency
    Variant.active_currency = (australia? ? "AUD" : "NZD")
  end
end
