require "spec_helper"

describe VolumePrice do
  before do
    @volume_price = VolumePrice.new
  end
  
  it "should return the correct price given the active currency" do
    @volume_price.price.should be_nil
    
    Site.active_currency = "USD"
    @volume_price.currency_prices = "NZD:23"
    @volume_price.price.should be_nil
    
    Site.active_currency = "NZD"
    @volume_price.price.should == 23
  end
  
  it "should allow a blank price attribute" do
    @volume_price.should have(0).errors_on(:price)
  end
end
