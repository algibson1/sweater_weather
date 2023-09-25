class User < ApplicationRecord 
  validates_presence_of :email, :api_key
  validates :email, uniqueness: { case_sensitive: false }

  has_secure_password

  def generate_key 
    chars = ('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a
    update(api_key: chars.shuffle.take(32).join(""))
  end
end