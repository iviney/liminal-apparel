VolumePrice.class_eval do
  remove_validator :presence, :price
  remove_validator :numericality, :price
  
  include Models::MultipleCurrencies
  
  def price
    price_using_active_currency
  end
end
