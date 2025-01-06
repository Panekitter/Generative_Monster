class User < ApplicationRecord
  has_many :characters, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      is_new_user = false
      user = find_or_initialize_by(email: auth_hash.info.email) do |user|
        is_new_user = true
        user.name = "temp"
        user.save!
        user.update!(name: generate_username(user.id))
      end
      [user, is_new_user]
    end

    private

    def generate_username(user_id)
      "user_#{user_id}"
    end
  end
end
