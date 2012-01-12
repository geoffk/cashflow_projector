require 'date'

module CashflowProjector  
  class Projector
    def initialize
      @accounts = []
    end
  
    def self.setup(&block)
        self.new.instance_eval(&block);
    end
  
    def biweekly(date)
      Period.biweekly(date)
    end
  
    def monthly(day_of_month)
      Period.monthly(day_of_month)
    end
  
    def bimonthly(month,day)
      Period.bimonthly(month,day)
    end
  
    def annually(month,day)
      Period.annually(month,day)
    end
  
    def account(name, value)
      a = Account.new(name,value)
      @accounts << a
      a
    end
  
    def account_balances
      @accounts.collect{|a| a.balance}
    end
  
    def print_results(start_date, start_balances, acts)
      str = "DATE       "
      @accounts.each do |a|
        str << "%15s " % a.to_s[0,15]
      end
      str << "\n"
      str << "%s " % start_date
      start_balances.each do |bal|
        str << "% 15.2f " % bal
      end
      str << "\n"
      acts.each do |a|
        str << a.to_formatted_string + "\n"
      end
      str
    end
  
    def run(start_date, end_date)
      acts = []
      start_balances = account_balances
      (start_date .. end_date).each do |date|
        @accounts.each do |account|
          a = account.do_transactions(date)
          a.each{|desc| desc.account_balances = account_balances}
          acts += a
        end
      end
      print_results(start_date,start_balances,acts)
    end
  
  end
  
  class Account
    attr_reader :name, :amount, :periodic_activities
  
    def initialize(name, amount)
      @name = name
      @amount = amount
      @periodic_activities = []
      @transaction_activities = []
    end
  
    def balance
      @amount
    end
  
    def deposit(amount)
      @amount += amount
    end
  
    def withdraw(amount)
      @amount -= amount
    end
  
    def payment_from(target, amount, period, options = {})
      @periodic_activities << PeriodicActivity.new(target, :from, amount, period, options)
    end
    alias :transfer_from :payment_from
  
    def payment_to(target, amount, period, options = {})
      @periodic_activities << PeriodicActivity.new(target, :to, amount, period, options)
    end
    alias :transfer_to :payment_to
  
    def do_transactions(date)
      acts = []
      @periodic_activities.each do |act|
        if (act.transacts_on?(date))
          a =act.do_transaction(self)
          a.date = date
          acts << a
        end
      end
      return acts
    end
  
    def to_s
      @name
    end
  end
  
  class Period
    def self.biweekly(first_date)
      p = Proc.new do |date|
        ((date - first_date) % 14)  == 0
      end
      Period.new(p)
    end
  
    def self.bimonthly(month,day)
      p = Proc.new do |date|
        date.day == day && ((date.month - month) % 2) == 0
      end
      Period.new(p)
    end
  
    def self.monthly(day_of_month)
      p = Proc.new do |date|
        date.day == day_of_month
      end
      Period.new(p)
    end
  
    def self.annually(month, day)
      p = Proc.new do |date|
        date.day == day && date.month == month
      end
  
      Period.new(p)
    end
  
    def initialize(match_proc)
      @match_proc = match_proc
    end
  
    def falls_on?(date)
      @match_proc.call(date)
    end
  end
  
  class PeriodicActivity
    def initialize(target, direction, amount, period, options = {})
      @target = target
      @direction = direction
      @amount = amount
      @period = period
      @options = options  # Not used
    end
  
    def transacts_on?(date)
      @period.falls_on?(date)
    end
  
    def do_transaction(src)
      if(@direction == :to)
        src.withdraw(@amount)
        @target.deposit(@amount) if @target.is_a?(Account)
        return TransactionDescription.new(src.to_s, @target.to_s, @amount)
      elsif(@direction == :from)
        src.deposit(@amount)
        @target.withdraw(@amount) if @target.is_a?(Account)
        return TransactionDescription.new(@target.to_s, src.to_s, @amount)
      else
        raise "Bad direction:#{direction}"
      end
    end
  end
  
  class TransactionDescription
    attr_accessor :from, :to, :amount, :date, :account_balances, :type
  
    def initialize(from,to,amount)
      @from = from
      @to = to
      @amount = amount
      @account_balances = []
    end
  
    def to_formatted_string
      str = date.to_s + " "
      account_balances.each do |bal|
        str += "% 15.2f " % bal
      end
      str += "  #{"% 10.2f" % amount} from '#{from.to_s}' to '#{to.to_s}'"
      str
    end
  end

end
