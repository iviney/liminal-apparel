CheckoutController.class_eval do
  before_filter :only_allow_active_country, :only => :update
  
  def paypal_site_opts
    {
      :currency => @order.currency,
      :header_image => "https://app.churchoffice.org.nz#{Spree::Config[:logo]}"
    }
  end

  private
    def only_allow_active_country
      if params[:order] and attributes = params[:order][:bill_address_attributes]
        attributes[:country_id] = active_country.id
      end
    end
end
