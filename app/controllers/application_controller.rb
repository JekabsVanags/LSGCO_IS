class ApplicationController < ActionController::Base
  
  private

  def current_user 
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end

  def authorized?
    if !current_user.present?
      redirect_to root_path, alert: "Nav atļauts"
    end
  end

  helper_method :current_user
end
