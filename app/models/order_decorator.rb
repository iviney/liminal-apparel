Order.class_eval do
  before_create :set_currency
  
  attr_protected :currency

  def adjustments_with_tax_last # returns adjustments, but sorted so all tax adjustments are last in the list
    adj = self.adjustments
    adj.select { |a| a.originator_type!="TaxRate"} + adj.select { |a| a.originator_type=="TaxRate"}  # put tax adjustments at the end
  end

  def australia?
    self.currency == "AUD"
  end

  private
    def set_currency
      self.currency = Site.active_currency
    end
end
