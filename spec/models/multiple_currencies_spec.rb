require "spec_helper"

describe "a model with Models::MultipleCurrencies included" do
  before :each do
    @volume_price = VolumePrice.new
  end
  
  it "should return the correct currency prices hash" do
    @volume_price.currency_prices = "NZD:23"
    @volume_price.currency_prices_hash.should == { "NZD" => BigDecimal("23") }
    
    @volume_price.currency_prices = "NZD:23 AUD:20"
    @volume_price.currency_prices_hash.should == { "NZD" => BigDecimal("23"), "AUD" => BigDecimal("20") }
    
    @volume_price.currency_prices = "NZD:23 20"
    @volume_price.currency_prices_hash.should == { "NZD" => BigDecimal("23") }
    
    @volume_price.currency_prices = "NZD:23 AUD"
    @volume_price.currency_prices_hash.should == { "NZD" => BigDecimal("23") }
  end
  
  it "should give an error when required currency not present" do
    @volume_price.currency_prices = "NZD:23"
    @volume_price.should have(1).errors_on(:base)
  end
end
