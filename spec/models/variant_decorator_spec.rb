require "spec_helper"

describe Variant do
  before :each do
    @product = Product.create!(:name => "Product 1", :price => 9999, :currency_prices => "NZD:20 AUD:10")
  end
  
  it "should get the current currency price from the master variant" do
    Site.active_currency = "NZD"
    @product.price.should == 20
    
    Site.active_currency = "AUD"
    @product.price.should == 10
    
    Site.active_currency = nil
    @product.price.should be_nil
  end
  
  it "should look at the master to determine the price" do
    @variant = @product.variants.create!
    @variant.currency_prices.should be_nil
    
    Site.active_currency = "NZD"
    @variant.price.should == 20
  end
end
