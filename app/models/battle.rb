class Battle < ApplicationRecord
  belongs_to :user
  belongs_to :character_1, class_name: 'Character', optional: true
  belongs_to :character_2, class_name: 'Character', optional: true
  belongs_to :winner_user, class_name: 'User', optional: true

  DAILY_BATTLE_LIMIT = 10
end
