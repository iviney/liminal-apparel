Variant.class_eval do
  include Models::MultipleCurrencies
  
  remove_validator :presence, :price
  
  def price
    if product and product.master
      product.master.price_using_active_currency
    else
      self[:price]
    end
  end
  
  private
    # Not required now that per-currency pricing is used.
    def check_price
    end
    
    def validate_currency_columns?
      is_master?
    end
end
