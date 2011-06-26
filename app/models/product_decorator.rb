Product.class_eval do
  remove_validator :presence, :price
  
  delegate_belongs_to :master, :currency_prices
end
