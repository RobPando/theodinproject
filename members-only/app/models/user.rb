class User < ActiveRecord::Base
  before_create :create_remember_token

  has_secure_password
  validates :password, confirmation: true


  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    def create_remember_token
      self.remember_token = User.digest(User.new_token)
    end
end
