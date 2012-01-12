require 'spec_helper'

include CashflowProjector

describe Period do
  before(:each) do
    @d = Date.new(2012,1,1)
  end

  it "should work for biweekly" do
    p = Period.biweekly(@d)

    p.falls_on?(@d).should be_true
    p.falls_on?(@d+14).should be_true
    p.falls_on?(@d-14).should be_true

    p.falls_on?(@d+1).should be_false
    p.falls_on?(@d-1).should be_false
    p.falls_on?(@d+7).should be_false
    p.falls_on?(@d+13).should be_false
  end

  it "should work for bimonthly" do
    p = Period.bimonthly(3,1)

    p.falls_on?(Date.new(2012,3,1)).should be_true
    p.falls_on?(Date.new(2012,5,1)).should be_true
    p.falls_on?(Date.new(2011,11,1)).should be_true

    p.falls_on?(Date.new(2011,11,2)).should be_false
    p.falls_on?(Date.new(2011,2,28)).should be_false
  end

  it "should work for monthly" do
    p = Period.monthly(15) 
    
    p.falls_on?(Date.new(2012,3,15)).should be_true
    p.falls_on?(Date.new(2012,2,15)).should be_true
    p.falls_on?(Date.new(2012,8,15)).should be_true
  
    p.falls_on?(Date.new(2012,3,16)).should be_false
    p.falls_on?(Date.new(2012,3,14)).should be_false
  end

  it "should work for annually" do
    p = Period.annually(3,15)

    p.falls_on?(Date.new(2012,3,15)).should be_true
    p.falls_on?(Date.new(2022,3,15)).should be_true

    p.falls_on?(Date.new(2012,2,15)).should be_false
    p.falls_on?(Date.new(2012,3,16)).should be_false
  end

end



