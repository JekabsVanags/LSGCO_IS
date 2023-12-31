class ApplicationController < ActionController::Base
  private

  def current_user #Aktīvais lietotājs
    return unless session[:user_id]

    @current_user = User.find(session[:user_id])
  end

  def current_tab #Pašreizējā lentenes sadaļa
    return unless session[:current_tab]

    @current_tab = session[:current_tab]
  end

  def authorized? #Vai lietotājs ir reģistrējies un kāds tā piekļuves līmenis
    if !current_user.present?
      redirect_to root_path, alert: "Tu neesi piereģistrējies"
    else
      @user_permission_level = current_user.permission_level
    end
  end

  def unit_access? #Lietotāja piekļuve ir vienība vai lielāka
    return if current_user.pklv_vaditajs? || current_user.pklv_valde?

    redirect_to root_path, alert: "Nav atļauts"
  end

  def org_access? #Lietotāja piekļuve ir valde
    return if current_user.pklv_valde?

    redirect_to root_path, alert: "Nav atļauts"
  end

  def unit_active? #Vienība ir aktīva
    return unless !current_user.unit.unit_active?

    redirect_to root_path, alert: "Vienība neaktīva"
  end

  helper_method :current_user, :current_tab
end
