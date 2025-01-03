class User < ApplicationRecord
  has_many :characters, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  class << self
    def find_or_create_from_auth_hash(auth_hash)
      is_new_user = false
      user = nil

      ActiveRecord::Base.transaction do
        user = find_or_create_by(email: auth_hash.info.email) do |user|
          is_new_user = true
          user.save!
        end
        user.update!(name: generate_username(user.id)) if user.name.blank?
      end
      [user, is_new_user]
    end

    private

    def generate_username(user_id)
      "user_#{user_id}"
    end
  end
end
