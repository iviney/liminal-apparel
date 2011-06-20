require "spec_helper"

describe VolumePrice do
  before do
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
  
  it "should return the correct price given the active currency" do
    @volume_price.price.should be_nil
    
    @volume_price.currency_prices = "NZD:23"
    @volume_price.price.should be_nil
    
    Site.active_currency = "NZD"
    @volume_price.price.should == 23
  end
  
  it "should allow a blank price attribute" do
    @volume_price.should have(0).errors_on(:price)
  end
  
  it "should give an error when required currency not present" do
    @volume_price.currency_prices = "NZD:23"
    @volume_price.should have(1).errors_on(:base)
  end
end
