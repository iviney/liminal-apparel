VolumePrice.class_eval do
  # Remove the validation from the now unused price attribute.
  _validators.delete(:price)
  # Remove bot the presence and numericality validators
  _validate_callbacks.pop
  _validate_callbacks.pop
  
  validates :currency_prices, :presence => true
  
  validate :validate_required_currencies_present
  
  # Replace the price accessor with one that is based on the active currency.
  def price
    active_currency_price
  end
  
  # The currency_prices column should be populated with data like "NZD:30 AUD:25"
  def currency_prices_hash
    currency_prices.to_s.split(" ").inject({}) do |hash, s|
      k, v = s.split(":", 2)
      hash[k] = BigDecimal(v) if k && v
      hash
    end
  end
  
  def active_currency_price
    currency_prices_hash[Site.active_currency]
  end
  
  def validate_required_currencies_present
    if required_currencies = Spree::Config[:required_currencies]
      required_currencies.split.each do |currency|
        unless currency_prices_hash.include?(currency)
          errors.add :base, "Price missing for #{currency}"
        end
      end
    end
  end
end
