require "spec_helper"

describe Calculator::SalesTax do
  let(:order) { Factory(:order) }
  let(:tax_category) { TaxCategory.create!(:name => "Taxable", :is_default => true) }
  let(:tax_rate) { TaxRate.create!(:tax_category => tax_category, :amount => 0.15) }
  let(:calculator) { Calculator::SalesTax.create!(:calculable => tax_rate) }
  
  it "should calculate tax on the order adjustments" do
    order.stub(:adjustments => [
      mock_model(Adjustment, :originator_type => "ShippingMethod", :amount => BigDecimal("10")),
      mock_model(Adjustment, :originator_type => "Donkey", :amount => BigDecimal("21.44"))
    ])
    
    calculator.compute(order).should == BigDecimal("4.72")
  end
  
  it "should not calculate tax on order adjustments that are tax" do
    order.stub(:adjustments => [
      mock_model(Adjustment, :originator_type => "TaxRate", :amount => BigDecimal("10")),
      mock_model(Adjustment, :originator_type => "Donkey", :amount => BigDecimal("21.44"))
    ])
    
    calculator.compute(order).should == BigDecimal("3.22")
  end
  
  it "should calculate tax on line items without tax categories" do
    order.stub(:line_items => [
      mock_model(LineItem, :total => BigDecimal("24"), :product => mock_model(Product, :tax_category => nil)),
      mock_model(LineItem, :total => BigDecimal("12"), :product => mock_model(Product, :tax_category => nil))
    ])
    
    calculator.compute(order).should == BigDecimal("5.4")
  end
  
  it "should not calculate tax on line items with different tax categories" do
    other_tax_category = TaxCategory.create!(:name => "Other")
    
    order.stub(:line_items => [
      mock_model(LineItem, :total => BigDecimal("24"), :product => mock_model(Product, :tax_category => other_tax_category)),
      mock_model(LineItem, :total => BigDecimal("12"), :product => mock_model(Product, :tax_category => tax_category))
    ])
    
    calculator.compute(order).should == BigDecimal("1.8")
  end
  
  it "should calculate tax on line items and adjustments" do
    other_tax_category = TaxCategory.create!(:name => "Other")
    
    order.stub(:line_items => [
      mock_model(LineItem, :total => BigDecimal("24"), :product => mock_model(Product, :tax_category => other_tax_category)),
      mock_model(LineItem, :total => BigDecimal("12"), :product => mock_model(Product, :tax_category => tax_category)),
      mock_model(LineItem, :total => BigDecimal("29"), :product => mock_model(Product, :tax_category => nil))
    ])
    
    order.stub(:adjustments => [
      mock_model(Adjustment, :originator_type => "TaxRate", :amount => BigDecimal("10")),
      mock_model(Adjustment, :originator_type => "Donkey", :amount => BigDecimal("21.44"))
    ])
    
    calculator.compute(order).should == BigDecimal("9.37")
  end
end
