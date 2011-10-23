CheckoutController.class_eval do
  before_filter :only_allow_active_country, :only => :update
  
  private
  
  def paypal_site_opts
    {
      :currency => @order.currency,
      :header_image => "https://app.churchoffice.org.nz#{Spree::Config[:logo]}"
    }
  end

  # Update the tax calculation
  def order_opts_with_tax_fix(order, payment_method, stage)
    opts = order_opts_without_tax_fix(order, payment_method, stage)
    
    # Old: :tax => ((order.adjustments.map { |a| a.amount if ( a.source_type == 'Order' && a.label == 'Tax') }.compact.sum) * 100 ).to_i
    opts[:tax] = ((order.adjustments.map { |a| a.amount if ( a.source_type == 'Order' && a.originator_type == 'TaxRate') }.compact.sum) * 100).to_i
    
    # The new tax calculation should be used to calculate the handling charge
    if stage == "payment"
      #hack to add float rounding difference in as handling fee - prevents PayPal from rejecting orders
      #because the integer totals are different from the float based total. This is temporary and will be
      #removed once Spree's currency values are persisted as integers (normally only 1c)
      opts[:handling] =  (order.total*100).to_i - opts.slice(:subtotal, :tax, :shipping).values.sum
    end
    
    opts
  end
  
  if private_instance_methods.include?("order_opts")
    alias_method_chain :order_opts, :tax_fix
  end
  
  def only_allow_active_country
    if params[:order] and attributes = params[:order][:bill_address_attributes]
      attributes[:country_id] = active_country.id
    end
  end
end
