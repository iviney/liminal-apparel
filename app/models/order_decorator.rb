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

  # ===================================================================================================================
  # Redefine #rate_hash to cope with admin-only shipping methods - see \spree_core-0.50.4\app\models\order.rb
  def rate_hash
    @rate_hash ||= available_shipping_methods(:front_end).collect do |ship_method|
      next if ship_method.admin_only && !user.roles.any? {|r| r.name == "admin"} # ignore method if it's admin only and our user does not have an admin role
      next unless cost = ship_method.calculator.compute(self)
      { :id => ship_method.id,
        :shipping_method => ship_method,
        :name => ship_method.name,
        :cost => cost
      }
    end.compact.sort_by{|r| r[:cost]}
  end

  private
    def set_currency
      self.currency ||= Site.active_currency
    end
end
