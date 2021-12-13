class PresetOwner < ApplicationRecord
  belongs_to :player
  has_many :presets
end
