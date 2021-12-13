class PlayersController < ApplicationController
  skip_before_action :require_login, only: %i[index create]
  before_action :check_input_null, :check_user_id_exist, :check_password_correct, :check_login_twice, only: [:home]

  def index; end

  def home
    @current_player_id = params[:user_id]
    @leader_board_lines = LeaderBoard.all
    @rooms = Room.all_room
  end

  def create
    if params[:user_id].nil?
      random_array = Array.new(10) { rand(1..9) }
      @user_id = random_array.join('')
    else
      user_id = params[:user_id]
      player_name = params[:player_name]
      password = params[:password]

      Player.create(user_id: user_id, player_name: player_name, password: password,
                    is_login: false, is_gaming: false)
      redirect_to '/'
    end
  end

  def check_password_correct
    user_id = params[:user_id]
    player = Player.find_by(user_id: user_id)
    if params[:password].to_s != player.password.to_s
      flash[:error] = 'The password is incorrect.'
      redirect_to '/'
    end
  end

  def check_input_null
    if params[:user_id].to_s == ''
      flash[:error] = "Player ID can't be NULL."
      redirect_to '/'
    elsif params[:password].to_s == ''
      flash[:error] = "Password can't be NULL."
      redirect_to '/'
    end
  end

  def check_user_id_exist
    user_id = params[:user_id].to_s
    player = Player.find_by(user_id: user_id)
    if player.nil?
      flash[:error] = "Player ID doesn't exist."
      redirect_to '/'
    end
  end

  def check_login_twice
    player = Player.find_by(user_id: params[:user_id].to_s)
    if player.is_login
      flash[:error] = 'Login twice is not allowed.'
      redirect_to '/'
    end
  end
end
