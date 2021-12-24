class GameOverController < ApplicationController
  def index
    @user_id = params[:user_id]
    win_player_id = params[:win_player_id]
    win_hand = params[:win_hand]

    # room_id = params[:room_id]
    # Room.delete_one_room(room_id)

    if !win_player_id.nil?
      @game_result = "#{win_hand} hand: #{win_player_id} win."
      @password = Player.get_password_by_id(win_player_id)
    else
      @game_result = 'You failed.'
      @password = Player.get_password_by_id(@user_id)
    end
  end
end
