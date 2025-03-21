class Character < ApplicationRecord
  mount_uploader :image, CharacterImageUploader

  before_destroy :remove_image!

  belongs_to :user
  has_many :skills, dependent: :destroy
  has_many :battles_as_character_1, class_name: 'Battle', foreign_key: :character_1_id, dependent: :nullify
  has_many :battles_as_character_2, class_name: 'Battle', foreign_key: :character_2_id, dependent: :nullify

  validates :name, presence: true
  validates :description, presence: true
  validates :hp, presence: true
  validates :agility, presence: true
  validates :strength, presence: true
  validates :intelligence, presence: true
  # validates :image, presence: true

  DAILY_CHARACTER_LIMIT = 2

  private

  def remove_image!
    image.remove! if image.present?
  rescue => e
    Rails.logger.error("Failed to remove image: #{e.message}")
  end
end
