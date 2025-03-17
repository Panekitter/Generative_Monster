class User < ApplicationRecord
  mount_uploader :image, UserImageUploader

  before_destroy :remove_image!

  has_many :characters, dependent: :destroy
  has_many :battles, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  def remove_image!
    image.remove! if image.present?
  rescue => e
    Rails.logger.error("Failed to remove image: #{e.message}")
  end

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
