require 'spec_helper'

include CashflowProjector

describe Projector do
  it "should work inside block" do
    Projector.setup do
      a = account 'Checking', 1000.00
      a.payment_from('Work', 50.00, biweekly( Date.new(2010,1,1) ))
      a.payment_to('AT&T', 50.00, monthly(15) )
      a.payment_to('SoCal Gas', 50.00, bimonthly(5,1))
      a.payment_to('IRS', 400.00, annually(4,15))
      run( Date.new(2010,1,1), Date.new(2011,5,1) )
      a.balance.should == 700
    end
  end
end



