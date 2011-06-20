Variant.class_eval do
  def price
    product.master.active_currency_price || self[:price]
  end
  
  def currency_prices_hash
    currency_prices.to_s.split(" ").inject({}) do |hash, s|
      k, v = s.split(":")
      hash[k] = BigDecimal(v)
      hash
    end
  end
  
  def active_currency_price
    currency_prices_hash[Site.active_currency]
  end
end
