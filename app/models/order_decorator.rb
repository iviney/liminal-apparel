Order.class_eval do
  before_create :set_currency
  
  attr_protected :currency
  
  private
    def set_currency
      self.currency = Site.active_currency
    end
end
