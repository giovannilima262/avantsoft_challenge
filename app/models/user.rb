class User < ApplicationRecord
  has_secure_password

  def self.generate_token(user)
    JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
  end
end
