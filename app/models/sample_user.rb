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

  def self.auth_with_hashing hashed_password
    Digest::MD5.hexdigest(self.instance.password) == hashed_password
  end

  def self.change_password password
    ins = self.instance
    ins.password = password
    ins.save!
  end

  def self.is_authenticated session
    if session[:auth_time] and session[:auth_time] >= Time.now - 10.minutes
      if SampleUser.auth_with_hashing session[:password]
        return true
      end
    end
    false
  end

  def self.after_auth session
    session[:auth_time] = Time.now
    session[:password] = Digest::MD5.hexdigest(self.instance.password)
  end
end
