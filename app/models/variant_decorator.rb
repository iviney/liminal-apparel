Variant.class_eval do
  def self.active_currency
    Thread.current[:active_currency]
  end
  
  def self.active_currency=(currency)
    Thread.current[:active_currency] = currency
  end
  
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
    currency_prices_hash[self.class.active_currency || "NZD"]
  end
end
