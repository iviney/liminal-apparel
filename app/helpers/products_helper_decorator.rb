module ProductsHelper

# Adds a version of product_price to include GST for NZ.  TBD do this more properly somehow.

# returns the price of the product to show for display purposes
  def product_price_incl_tax(product_or_variant, options={})
    options.assert_valid_keys(:format_as_currency, :show_vat_text)
    options.reverse_merge! :format_as_currency => true, :show_vat_text => Spree::Config[:show_price_inc_vat]

    amount = product_or_variant.price
    amount *= 1.15 if !australia? # TBD fix ghastly hard-wiring of NZ tax percentage

    options.delete(:format_as_currency) ? format_price(amount, options) : amount
  end
end
