class Character < ApplicationRecord
  mount_uploader :image, CharacterImageUploader

  belongs_to :user
  has_many :skills, dependent: :destroy
  has_many :battles_as_character_1, class_name: 'Battle', foreign_key: :character_1_id
  has_many :battles_as_character_2, class_name: 'Battle', foreign_key: :character_2_id

  validates :name, presence: true
  validates :description, presence: true
  validates :hp, presence: true
  validates :agility, presence: true
  validates :strength, presence: true
  validates :intelligence, presence: true
  # validates :image, presence: true
end
