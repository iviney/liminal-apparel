Spree::BaseController.class_eval do
  before_filter :set_currency
  
  def set_currency
    Variant.active_currency = (australia? ? "AUD" : "NZD")
  end
  
  def australia?
    request.host.ends_with?(".au") || params[:au]
  end
end
