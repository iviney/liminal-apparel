require "spec_helper"

describe Product do
  before :each do
    @product = Product.create!(:name => "Product 1", :currency_prices => "")
  end
  
  it "should set the currency prices on the master variant" do
    @product.update_attributes!(:currency_prices => "NZD:10 AUD:20")
    @product.reload
    @product.currency_prices.should == "NZD:10 AUD:20"
    @product.master.currency_prices.should == @product.currency_prices
  end
end
