require 'spec_helper'

include CashflowProjector

describe PeriodicActivity do
  before(:each) do
    @acct1 = double('account 1', :is_a? => true)
    @acct2 = double('account 2', :is_a? => true)
    @period_always = double('period always', :falls_on? => true)
    @period_never = double('period never', :falls_on? => false)
  end

  it "should know when the period doesn't match" do
    pa = PeriodicActivity.new(@acct1,:to,100,@period_never)
    pa.transacts_on?(Date.today).should be_false
  end

  it "should know when the period does match" do
    pa = PeriodicActivity.new(@acct1,:to,100,@period_always)
    pa.transacts_on?(Date.today).should be_true
  end

  it "should move money correctly using :to" do
    pa = PeriodicActivity.new(@acct2,:to,100,@period_always)
    @acct1.should_receive(:withdraw).with(100)
    @acct2.should_receive(:deposit).with(100)
    pa.do_transaction(@acct1).should be_a(TransactionDescription)
  end

  it "should move money correctly using :from" do
    pa = PeriodicActivity.new(@acct1,:from,100,@period_always)
    @acct1.should_receive(:withdraw).with(100)
    @acct2.should_receive(:deposit).with(100)
    pa.do_transaction(@acct2).should be_a(TransactionDescription)
  end

  it "should work with just a string on :to" do
    pa = PeriodicActivity.new('test',:to,100,@period_always)
    @acct1.should_receive(:withdraw).with(100)
    pa.do_transaction(@acct1).should be_a(TransactionDescription)
  end

  it "should work with just a string on :from" do
    pa = PeriodicActivity.new('test',:from,100,@period_always)
    @acct1.should_receive(:deposit).with(100)
    pa.do_transaction(@acct1).should be_a(TransactionDescription)
  end

end



