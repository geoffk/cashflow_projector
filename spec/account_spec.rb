require 'spec_helper'

include CashflowProjector

describe Account do
  before(:each) do
    @acct = Account.new('Account 1', 100)
  end

  it "should report and update a balance" do
    @acct.balance.should be(100)
    @acct.deposit(50)
    @acct.balance.should be(150)
    @acct.withdraw(75)
    @acct.balance.should be(75)
  end

  it "should have a name" do
    @acct.to_s.should == "Account 1"
  end

  it "should accept payment from activity" do
    @acct.payment_from('bank', 50, Period.monthly(15))
    @acct.periodic_activities.length.should be(1)
  end

  it "should accept payment to activity" do
    @acct.payment_to('bank', 50, Period.monthly(15))
    @acct.periodic_activities.length.should be(1)
  end

  it "should run activities only when period matches" do
    @acct.payment_to('bank', 50, Period.monthly(15))
    @acct.payment_to('bank', 50, Period.monthly(16))
    @acct.do_transactions( Date.new(2010,12,15) )
    @acct.balance.should be(50)
  end

end



