class Statistic < ActiveRecord::Base
  attr_accessible :enter, :open, :cancel, :rescan, :result_print

  def self.instance
    ins = Statistic.first
    unless ins
      ins = Statistic.create(:enter => 0,
                             :open => 0,
                             :cancel => 0,
                             :rescan => 0,
                             :result_print => 0)
    end
    return ins
  end

  def reset
    self.enter = 0
    self.open = 0
    self.cancel = 0
    self.rescan = 0
    self.result_print = 0
    self.save!
  end

  def self.reset
    Statistic.instance.reset
  end

  def self.on_enter
    ins = Statistic.instance
    ins.enter += 1
    ins.save!
  end

  def self.on_open
    ins = Statistic.instance
    ins.open += 1
    ins.save!
  end

  def self.on_cancel
    ins = Statistic.instance
    ins.cancel += 1
    ins.save!
  end

  def self.on_rescan
    ins = Statistic.instance
    ins.rescan += 1
    ins.save!
  end

  def self.on_print
    ins = Statistic.instance
    ins.result_print += 1
    ins.save!
  end
end
