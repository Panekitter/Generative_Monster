class Battle < ApplicationRecord
  belongs_to :character_1, class_name: 'Character', optional: true
  belongs_to :character_2, class_name: 'Character', optional: true
end
