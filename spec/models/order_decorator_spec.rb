require "spec_helper"

describe Order do
  it { should_not allow_mass_assignment_of :currency }
  
  it "should set the currency field" do
    Order.create!.reload.currency.should be_nil
    
    currency! "NZD"
    Order.create!.reload.currency.should == "NZD"
  end
end
