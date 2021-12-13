Rails.application.routes.draw do
  root 'players#index'

  get '/game_result', to: 'game_over#index'

  put '/preset_chess_layout', to: 'preset_chess_layouts#choose'

  post '/preset', to: 'presets#create'
  get '/preset', to: 'presets#create'

  post '/room', to: 'rooms#create'

  post '/real_time_info', to: 'preset_chess_layouts#prepared'
  get '/real_time_info', to: 'real_time#playing'
  put '/real_time_info', to: 'real_time#playing'

  post '/player/authority', to: 'players#home'
  get '/player/authority', to: 'players#home'
  post '/player', to: 'players#create'
end
