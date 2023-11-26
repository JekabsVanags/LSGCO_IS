class ApplicationController < ActionController::Base
  private

  def current_user
    return unless session[:user_id]

    @current_user = User.find(session[:user_id])
  end

  def current_tab
    return unless session[:current_tab]

    @current_tab = session[:current_tab]
  end

  def authorized?
    if !current_user.present?
      redirect_to root_path, alert: "Tu neesi piereģistrējies"
    else
      @user_permission_level = current_user.permission_level
    end
  end

  def unit_access?
    return if current_user.pklv_vaditajs? || current_user.pklv_valde?

    redirect_to root_path, alert: "Nav atļauts"
  end

  def org_access?
    return if current_user.pklv_valde?

    redirect_to root_path, alert: "Nav atļauts"
  end

  helper_method :current_user, :current_tab
end
