  # Computes sales tax for line_items associated with order, and includes shipping (and other adjustments)
  # A default tax rate is used for shipping, since it doesn't have an associated tax category like a product does.
  # This is borrowed from https://github.com/dancinglightning/spree-vat-fix/blob/master/app/models/calculator/vat_decorator.rb

TaxRate.class_eval do
  def is_default?
    self.tax_category.is_default
  end
end

Calculator::SalesTax.class_eval do

  def compute(order)
    rate = self.calculable
                                    #puts "#{rate.id} RATE IS #{rate.amount}" if debug
    tax = 0
    if rate.tax_category.is_default #and !Spree::Config[ :show_price_inc_vat]
      order.adjustments.each do | adjust |
        next if adjust.originator_type == "TaxRate"
        add = adjust.amount * rate.amount
                                    #puts "Applying default rate to adjustment #{adjust.label} (#{adjust.originator_type} ), sum = #{add}"
        tax += add
      end
    end
    order.line_items.each do  | line_item|
      if line_item.product.tax_category  #only apply this calculator to products assigned this rate's category
        next unless line_item.product.tax_category == rate.tax_category
      else
        next unless is_default? # and apply to products with no category, if this is the default rate
                                    #TODO: though it would be a user error, there may be several rates for the default category
                                    #      and these would be added up by this.
      end
      next unless line_item.product.tax_category.tax_rates.include? rate
                                    #puts "COMPUTE for #{line_item.price} is #{ line_item.price * rate.amount} RATE IS #{rate.amount}" if debug
      tax += (line_item.price * rate.amount * line_item.quantity).round(2, BigDecimal::ROUND_HALF_UP) # round total, not item price
    end
    tax
  end
end
