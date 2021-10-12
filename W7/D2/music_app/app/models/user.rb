# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string           not null
#  session_token   :string           not null
#
class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  after_initialize :ensure_session_token

  def self.generate_session_token
    self.session_token = SecureRandom.new::urlsafe_arm64
  end

  def reset_session_token!
    self.session_token = session[:session_token]
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.new::urlsafe_arm64
  end

  def password=(password)
    self.password_digest = BCrypt.create(password)
  end

  def is_same_password?(password)
    pass = Bcrypt.new(self.password_digest)
    pass.is_password?(password)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email)
    if user
      return user if user.password_digest.is_same_password?(password)
      return nil
    else
      return nil
    end
  end

end