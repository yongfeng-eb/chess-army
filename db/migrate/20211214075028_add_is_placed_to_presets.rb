class AddIsPlacedToPresets < ActiveRecord::Migration[6.1]
  def change
    add_column :presets, :is_placed, :boolean
  end
end
