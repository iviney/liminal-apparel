Product.class_eval do
  delegate_belongs_to :master, :currency_prices
end
