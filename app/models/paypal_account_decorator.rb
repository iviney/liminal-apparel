# This method is taken from the Paypal Express extension.
# 
# The only change is to pass the currency of the original
# authorization through to Paypal to prevent currency errors.
PaypalAccount.class_eval do
  def capture(payment)
    authorization = find_authorization(payment)
    
    ppx_response = payment.payment_method.provider.capture(
      (100 * payment.amount).to_i,
      authorization.params["transaction_id"],
      :currency => authorization.params["gross_amount_currency_id"]
    )
    
    if ppx_response.success?
      record_log payment, ppx_response
      payment.complete
    else
      gateway_error(ppx_response.message)
    end
  end
end
