class Admin::PayNowsController < Admin::BaseController

  include ActionView::Helpers::NumberHelper # TBD see http://snippets.dzone.com/posts/show/1799
  
  resource_controller

  #TBD do we need this stuff?
  create.success.wants.html { redirect_to collection_url }
  update.success.wants.html { redirect_to collection_url }
  destroy.success.wants.js { render_js_for_destroy }

#  update.after :update_after
#  create.after :create_after


  def new
  end

  def create
    pay_now = PayNow.new(:amount => params[:pay_now][:amount], :user => current_user)
    if pay_now.save
      # Submit to_paypal
      begin
        new_dummy_order(pay_now.amount)

        #make_paypal_payment(pay_now)
      rescue Spree::GatewayError
        gateway_error "Gateway error making payment"
      end
    else
      flash[:error] = "Couldn't save QuickPay"
    end
    render 'new'
  end

  # This creates an order just for the purpose of taking a payment.  It has a single line item of a dummy product with SKU 00000 costing 0.01,
  # which is created if necessary (TBD).

  # It raises an exception if the order can't be created (TBD).

  def new_dummy_order(amount)
    if prod = Variant.find(:first, :conditions => {:sku => "00000"})
      order = Order.new
      order.email = current_user.email
      order.currency = "AUD" # TBD currency shouldn't be hardwired
      order.state = "payment" # pretend we're at the payment stage of checkout
      order.save!

      # Create a single line item
      line_item = order.add_variant(prod, (amount * 100).to_i) # each one costs a cent
      line_item.price = 0.01

      order.update! # update totals and stuff
      order.save! # return nil if failed, or order if OK # TBD deal with exception if validation fails

      # simulate GET "/orders/R635570521/checkout/paypal_payment?payment_method_id=842616225"
      session[:order_id] = order.id
      redirect_to "#{order_path(order)}/checkout/paypal_payment?payment_method_id=#{payment_method.id}"
    else
      nil # return nil if no SKU of 00000 found
    end
  end

  # This is the other approach of just making a Paypal payment directly.  Unfortunately (at least on the test system)
  # it always comes back pending.

  def make_paypal_payment(pay_now)

    opts = all_opts(pay_now)
    @gateway = paypal_gateway

    @ppx_response = @gateway.setup_purchase(opts[:money], opts)

    unless @ppx_response.success?
      gateway_error(@ppx_response)
      redirect_to edit_pay_now_path(pay_now)
      return
    end

    redirect_to (@gateway.redirect_url_for @ppx_response.token, :review => payment_method.preferred_review)
  rescue ActiveMerchant::ConnectionError => e
    gateway_error I18n.t(:unable_to_connect_to_gateway)
    redirect_to :back
  end

  def all_opts(pay_now)
    { :description             => "Goods from Liminal Apparel", # site details...
      :header_image            => "https://#{Spree::Config[:site_url]}#{Spree::Config[:logo]}",
      :background_color        => "ffffff",  # must be hex only, six chars
      :header_background_color => "ffffff",
      :header_border_color     => "ffffff",
      :allow_note              => true,
      :locale                  => Spree::Config[:default_locale],
      :req_confirm_shipping    => false,   # for security, might make an option later
      :user_action             => "commit",

      :currency                => "AUD", # TBD should be entered as part of paynow
      :header_image            => "https://app.churchoffice.org.nz#{Spree::Config[:logo]}",

      :email                   => pay_now.user.email,

      :return_url              => "http://"  + request.host_with_port + "/admin/pay_nows/#{pay_now.id}/paypal_confirm", #?payment_method_id=#{payment_method}",
      :cancel_return_url       => "http://"  + request.host_with_port + "/admin/pay_nows/#{pay_now.id}/edit",
      :order_id                => pay_now.id,
      :custom                  => pay_now.id,
      #:items                  => items,
      #:subtotal               => ((order.item_total * 100) + credits_total).to_i,
      #:tax                    => ((order.adjustments.map { |a| a.amount if ( a.source_type == 'Order' && a.label == 'Tax') }.compact.sum) * 100 ).to_i,
      #:shipping               => ((order.adjustments.map { |a| a.amount if a.source_type == 'Shipment' }.compact.sum) * 100 ).to_i,
      :money                   => (pay_now.amount * 100 ).to_i,
      :handling                => 0,
      :no_shipping             => true
    }
  end

  def paypal_confirm
    @pay_now = PayNow.find(params[:id])
    gateway = paypal_gateway

    @ppx_details = gateway.details_for params[:token]

    if succeeded = @ppx_details.success?
      opts = { :token => params[:token], :payer_id => params[:PayerID] }.merge all_opts(@pay_now)
      ppx_auth_response = gateway.purchase(opts[:money], opts)

      if succeeded = ppx_auth_response.success?
        #record status
        case ppx_auth_response.params["payment_status"]
        when "Completed"
          @pay_now.payment_state = 'paid'
          flash[:notice] = "Payment of #{number_to_currency(@pay_now.amount)} done."
        when "Pending"
          @pay_now.payment_state = 'pending'
          flash[:error] = "Payment of #{number_to_currency(@pay_now.amount)} pending."
        else
          succeeded = false
          @pay_now.payment_state = 'unknown'
          flash[:error] = "Payment of #{number_to_currency(@pay_now.amount)} is in an unknown state."
          Rails.logger.error "Unexpected response from PayPal Express"
          Rails.logger.error ppx_auth_response.to_yaml
        end
      else
        @pay_now.payment_state = 'failed'
        gateway_error(ppx_auth_response)      #Failed trying to complete pending payment!
      end
    else
      @pay_now.payment_state = 'failed'
      flash[:error] = "Payment of #{number_to_currency(@pay_now.amount)} failed."
    end

    @pay_now.save

    if succeeded
      redirect_to admin_url # TBD goto list of pay_nows
    else
      redirect_to edit_admin_pay_now_url(@pay_now) # if failed
    end
  rescue ActiveMerchant::ConnectionError => e
    gateway_error I18n.t(:unable_to_connect_to_gateway)
    redirect_to edit_admin_pay_now_url(@pay_now)
  end


      #PaypalAccount.create(:email => @ppx_details.params["payer"],
      #                     :payer_id => @ppx_details.params["payer_id"],
      #                     :payer_country => @ppx_details.params["payer_country"],
      #                     :payer_status => @ppx_details.params["payer_status"])

      #@order.special_instructions = @ppx_details.params["note"]


  private
  # These are pretty much copied from checkout_controller_decorator
  
  def gateway_error(response)
    if response.is_a? ActiveMerchant::Billing::Response
      text = response.params['message'] ||
             response.params['response_reason_text'] ||
             response.message
    else
      text = response.to_s
    end

    msg = "#{I18n.t('gateway_error')}: #{text}"
    logger.error(msg)
    flash[:error] = msg
  end

  def payment_method
    PaymentMethod.find(:first, :conditions => {:name => Rails.env.production? ? "Paypal Express": "Paypal Express (test)"})
  end

  def paypal_gateway
    payment_method.provider # assume it's found
  end

  def update_after
    Rails.cache.delete('pay_nows')
  end

  def create_after
    Rails.cache.delete('pay_nows')
  end

  def collection # see https://github.com/ernie/meta_search/tree/250c71772d30546d1b4a4134f51035610b4ba0bc
    @search = PayNow.metasearch(params[:search])
  end

end
