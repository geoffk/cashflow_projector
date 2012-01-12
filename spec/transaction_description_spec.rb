require 'spec_helper'

include CashflowProjector

describe TransactionDescription do
  before(:each) do
    @td = TransactionDescription.new('a','b',100)
  end

  it "provides the correct values in the accessors" do
    @td.from.should == 'a'
    @td.to.should == 'b'
    @td.amount.should be == 100
  end

end



