class ApplicationController < ActionController::Base
  before_action :require_login

  private

  def require_login
    user_id = params[:user_id]
    if user_id.nil?
      flash[:error] = 'You must be logged in to access this page.'
      redirect_to '/'
    end
  end
end
