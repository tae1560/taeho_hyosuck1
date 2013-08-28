class SampleUser < ActiveRecord::Base
  attr_accessible :password

  def self.instance
    user = SampleUser.first
    unless user
      SampleUser.create(:password => "0000")
    end
    return user
  end

  def self.auth password
    self.instance.password == password
  end

  def self.change_password password
    ins = self.instance
    ins.password = password
    ins.save!
  end
end
