CheckoutController.class_eval do
  before_filter :only_allow_active_country, :only => :update

  # ---------------------------------------------------------------------------------------------------------------------
  # This is a copy of paypal_payment from spree_paypal_express, with a change to catch extra errors (see '#NEW')
  def paypal_payment_with_socket_error_fix
    paypal_payment_without_socket_error_fix
  rescue SocketError
    gateway_error "Socket error" # TBD should use I18n.t
    redirect_to :back
  end

  if instance_method_names.include?("paypal_payment") and !instance_method_names.include?("paypal_payment_without_socket_error_fix")
    alias_method_chain :paypal_payment, :socket_error_fix
  end

  def update_registration # Fix bug in spree_core that didn't reset order state if update_attributes failed
    # hack - temporarily change the state to something other than cart so we can validate the order email address
    old_state = current_order.state
    current_order.state = "address" # this is the state we'd like to go to
    if current_order.update_attributes(params[:order])
      redirect_to checkout_path
    else
      current_order.state = old_state # but if the update failed (e.g. missing email address, go back to state we were in)
      @user = User.new
      render 'registration'
    end
  end

  private
  
  def paypal_site_opts
    {
      :currency => @order.currency,
      :header_image => "https://app.churchoffice.org.nz#{Spree::Config[:logo]}",

      # Override the line items with a single 'item' that is the total.  This is to make paypal work with volume discounts,
      # which paypal doesn't know about.
      :items => [{
         :name        => "Ordered items",
         :sku         => "00000",
         :quantity    => 1,
         :amount      => (@order.item_total * 100).to_i, # convert for gateway
         :weight      => 0,
         :height      => 0,
         :width       => 0,
         :depth       => 0
       }]
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
  
  if private_instance_methods.include?("order_opts") and !private_instance_methods.include?("order_opts_without_tax_fix")
    alias_method_chain :order_opts, :tax_fix
  end

  def only_allow_active_country
    if params[:order] and attributes = params[:order][:bill_address_attributes]
      attributes[:country_id] = active_country.id
    end
  end
end
