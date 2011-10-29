# Computes sales tax for line_items associated with order, and includes shipping (and other adjustments)
# A default tax rate is used for shipping, since it doesn't have an associated tax category like a product does.
# This is borrowed from https://github.com/dancinglightning/spree-vat-fix/blob/master/app/models/calculator/vat_decorator.rb

Calculator::SalesTax.class_eval do
  def compute(order)
    rate = self.calculable
    tax = 0
    
    if rate.tax_category.is_default
      order.adjustments.each do |adjust|
        next if adjust.originator_type == "TaxRate"
        adjustment_tax = (adjust.amount * rate.amount).round(2, BigDecimal::ROUND_HALF_UP)
        
        tax += adjustment_tax
      end
    end
    
    line_items = order.line_items.select { |i| i.product.tax_category.nil? || (i.product.tax_category == rate.tax_category) }
    line_items.each do |line_item|
      tax += (line_item.total * rate.amount).round(2, BigDecimal::ROUND_HALF_UP)
    end
    
    tax
  end
end
