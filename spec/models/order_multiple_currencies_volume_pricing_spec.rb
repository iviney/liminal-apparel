require "spec_helper"

describe "Order volume discounts" do
  before :each do
    @product = Product.create!(
      :name => "Test Product 1",
      :currency_prices => "NZD:30 AUD:25",
      :variants_use_master_discount => true
    )
    
    @product.master.volume_prices.create!(:starting_quantity => 5, :currency_prices => "NZD:25 AUD:20")
    @product.master.volume_prices.create!(:starting_quantity => 10, :currency_prices => "NZD:20 AUD:10")
    
    @variant = @product.variants.create!
    
  end
  
  it "should apply the volume discount to the order using the active currency" do
    Site.active_currency = "NZD"
    
    @order_1 = Order.create!
    item = @order_1.add_variant(@variant, 1)
    item.reload
    item.volume_discount.should == 0
    
    item = @order_1.add_variant(@variant, 5)
    item.reload
    item.volume_discount.should == -30
    
    item = @order_1.add_variant(@variant, 9)
    item.reload
    item.volume_discount.should == -150
    
    Site.active_currency = "AUD"
    
    @order_2 = Order.create!
    item = @order_2.add_variant(@variant, 10)
    item.reload
    item.volume_discount.should == -150
  end
end
