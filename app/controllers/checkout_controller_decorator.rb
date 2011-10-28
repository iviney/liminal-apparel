CheckoutController.class_eval do
  before_filter :only_allow_active_country, :only => :update
  
  def paypal_site_opts
    {
      :currency => @order.currency,
      :header_image => "https://app.churchoffice.org.nz#{Spree::Config[:logo]}"
    }
  end

# ---------------------------------------------------------------------------------------------------------------------
# This is a copy of paypal_payment from spree_paypal_express, with a change to catch extra errors (see '#NEW')
  def paypal_payment
    load_order
    opts = all_opts(@order,params[:payment_method_id], 'payment')
    opts.merge!(address_options(@order))
    @gateway = paypal_gateway

    if Spree::Config[:auto_capture]
      @ppx_response = @gateway.setup_purchase(opts[:money], opts)
    else
      @ppx_response = @gateway.setup_authorization(opts[:money], opts)
    end

    unless @ppx_response.success?
      gateway_error(@ppx_response)
      redirect_to edit_order_checkout_url(@order, :state => "payment")
      return
    end

    redirect_to (@gateway.redirect_url_for @ppx_response.token, :review => payment_method.preferred_review)
  rescue ActiveMerchant::ConnectionError => e
    gateway_error I18n.t(:unable_to_connect_to_gateway)
    redirect_to :back

  rescue SocketError                                      #NEW
    gateway_error "Socket error" # TBD should use I18n.t  #NEW
    redirect_to :back                                     #NEW
  end

# ---------------------------------------------------------------------------------------------------------------------
# This is a copy of order_opts from spree_paypal_express, with a change for tax calc (see '#OLD')
  def order_opts(order, payment_method, stage)
    items = order.line_items.map do |item|
      price = (item.price * 100).to_i # convert for gateway
      { :name        => item.variant.product.name,
        :description => (item.variant.product.description[0..120] if item.variant.product.description),
        :sku         => item.variant.sku,
        :quantity    => item.quantity,
        :amount      => price,
        :weight      => item.variant.weight,
        :height      => item.variant.height,
        :width       => item.variant.width,
        :depth       => item.variant.weight }
      end

    credits = order.adjustments.map do |credit|
      if credit.amount < 0.00
        { :name        => credit.label,
          :description => credit.label,
          :sku         => credit.id,
          :quantity    => 1,
          :amount      => (credit.amount*100).to_i }
      end
    end

    credits_total = 0
    credits.compact!
    if credits.present?
      items.concat credits
      credits_total = credits.map {|i| i[:amount] * i[:quantity] }.sum
    end

    opts = { #:return_url        => request.protocol + request.host_with_port + "/orders/#{order.number}/checkout/paypal_confirm?payment_method_id=#{payment_method}",
             :return_url        => "http://"  + request.host_with_port + "/orders/#{order.number}/checkout/paypal_confirm?payment_method_id=#{payment_method}",
             :cancel_return_url => "http://"  + request.host_with_port + "/orders/#{order.number}/edit",
             :order_id          => order.number,
             :custom            => order.number,
             :items             => items,
             :subtotal          => ((order.item_total * 100) + credits_total).to_i,
             #OLD: :tax         => ((order.adjustments.map { |a| a.amount if ( a.source_type == 'Order' && a.label == 'Tax') }.compact.sum) * 100 ).to_i,
             :tax               => ((order.adjustments.map { |a| a.amount if ( a.source_type == 'Order' && a.originator_type == 'TaxRate') }.compact.sum) * 100).to_i,
             :shipping          => ((order.adjustments.map { |a| a.amount if a.source_type == 'Shipment' }.compact.sum) * 100 ).to_i,
             :money             => (order.total * 100 ).to_i }

      # add correct tax amount by subtracting subtotal and shipping otherwise tax = 0 -> need to check adjustments.map
      #OLD: opts[:tax] = (order.total*100).to_i - opts.slice(:subtotal, :shipping).values.sum

    if stage == "checkout"
      opts[:handling] = 0

      opts[:callback_url] = "http://"  + request.host_with_port + "/paypal_express_callbacks/#{order.number}"
      opts[:callback_timeout] = 3
    elsif stage == "payment"
      #hack to add float rounding difference in as handling fee - prevents PayPal from rejecting orders
      #because the integer totals are different from the float based total. This is temporary and will be
      #removed once Spree's currency values are persisted as integers (normally only 1c)
      opts[:handling] =  (order.total*100).to_i - opts.slice(:subtotal, :tax, :shipping).values.sum
    end

    opts
  end

  private
    def only_allow_active_country
      if params[:order] and attributes = params[:order][:bill_address_attributes]
        attributes[:country_id] = active_country.id
      end
    end
end
