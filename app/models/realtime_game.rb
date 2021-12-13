class RealtimeGame < ApplicationRecord
  belongs_to :all_chess_per_hand
  belongs_to :blank_boards
end
