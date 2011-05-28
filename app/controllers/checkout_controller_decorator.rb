CheckoutController.class_eval do
  before_filter :only_allow_active_country, :only => :update
  
  private
    def only_allow_active_country
      if params[:order] and attributes = params[:order][:bill_address_attributes]
        attributes[:country_id] = active_country.id
      end
    end
end
