class UnitsController < ApplicationController
  #Pārbauda vai lietotājs ir autorizējies un vai tam ir pieteikamas piekļuves, vai ir vienības biedrs vai valde
  before_action :authorized?, :unit_access?, :unit_member?
  #Izveidot apskatīt un dzēst var tikai valdes pārstāvis
  before_action :org_access?, only: ["create", "index", "new", "destroy"]

  def new #Jauns vienības objekts ar noklusēto vērtību ar ko aizpildīt jaunas vienības formu
    session[:current_tab] = "new_unit"  #Iestatam, ka izvēlnes aktīvā sekcija ir jaunas vienības pievienošana
    @unit = Unit.new()
    @unit.membership_fee = 0
    @users = User.where(activity_statuss: "Vadītājs").map { |user| ["#{user.name} #{user.surname}", user.id] } #Vienību priekšnieku kandidāti
  end

  def index #Visas sistēmas vienības
    session[:current_tab] = "unit_list"
    @units = Unit.all
  end

  def show #Vienibas dati
    session[:current_tab] = "unit" unless session[:current_tab] == "unit_list" #Iestatam, ka izvēlnes aktīvā sekcija ir vienības apskate
    @unit = Unit.find(params[:id])
    @weekly_activities = @unit.weekly_activities.all.order(day: :asc)
    @members = @unit.users.where.not(activity_statuss: "Izstājies") #Aktīvie biedri
    @unit_leader = @unit.users.where(unit: @unit, permission_level: "pklv_vaditajs").first || @unit.users.where(permission_level: "pklv_valde", activity_statuss: "Vadītājs").first #Vienības priekšnieks
  end

  def create #Izveido jaunu vienību
    @leader = User.find(params[:leader_id])
    @unit = Unit.new(unit_create_params)
    @unit.membership_fee = 0 #Noklusējumā 0 dalības maksa

    #Saglabā jauno vienību un atjauno vienības priekšnieka piekļuves līmeni, paziņo
    if @unit.save! && @leader.update(permission_level: "pklv_vaditajs", unit: @unit) && @leader.activity_statuss == "Vadītājs"
      redirect_to unit_path(@unit), notice: "Jauna vienība izveidota"
    else
      redirect_to root_path, alert: "Kļūda"
    end
  end

  def edit #Vienības objekts ar ko aizpildīt vienības datu atjaunošanas formu
    @unit = Unit.find(params[:id])
    @weekly_activities = @unit.weekly_activities.all.order(day: :asc)
    @new_activity = WeeklyActivity.new #Tukšs iknedēļas nodarbības objekts
    @leader_candidates = @unit.users.where("activity_statuss = ? OR id = ?", 3, current_user.id).map { |user| ["#{user.name} #{user.surname}", user.id] } #Vienības priekšnieku kandindāti un esošie priekšnieki
  end

  def update #Vienības datu atjaunošana
    @unit = Unit.find(params[:id])
    @leader = params[:leader_id] ? User.find(params[:leader_id]) : @unit.unit_leader #Norādītais priekšnieks
    membership_fee = unit_update_params[:membership_fee].present? ? unit_update_params[:membership_fee] : 0  #Vienmēr jābūt dalības maksai

    if @leader != @unit.unit_leader #Ja priekšnieks mainīts, atjauno priekšnieku un tā piekļuves, un noņem vecā priekšnieka piekļuves
      if !@unit.unit_leader.pklv_valde?
        @unit.unit_leader.update(permission_level: "pklv_biedrs")
      end

      if !@leader.pklv_valde? #Ja valdes loceklis, nevajag mainīt piekļuves
        @leader.update(permission_level: "pklv_vaditajs")
      end
    end

    if @unit.update(unit_update_params.merge(membership_fee: membership_fee)) #Saglabājam vienības datus ar dalības maksu, ja kļūda Paziņo
      redirect_to unit_path(@unit), notice: "Vienības infromācija atjaunota"
    else
      redirect_to root_path, alert: "Kļūda"
    end
  end

  def destroy #Nestingrā dzēšana, ja neizdodas reģistrēt dzēšanas datumu Paziņo kļūdu
    @unit = Unit.find(params[:id])
    if @unit.update(deleted_at: Date.today)
      redirect_to unit_path(@unit), notice: "Vienības atzīmēta kā neaktīva"
    else
      redirect_to root_path, alert: "Kļūda"
    end
  end

  def undestory #Nestingrās dzēšanas atgriešana, ja neizdodas dzēst dzēšanas datumu Paziņo kļūdu
    @unit = Unit.find(params[:id])
    if @unit.update(deleted_at: nil)
      redirect_to unit_path(@unit), notice: "Vienības atzīmēta kā aktīva"
    else
      redirect_to root_path, alert: "Kļūda"
    end
  end

  protected

  #Pieņem vienības objektu, kas aizpildīts atļautajiem laukiem. Šo izmanto taisot jaunu vienību.
  def unit_create_params
    params.require(:unit).permit(:city, :number, :legal_adress, :bank_account)
  end

  #Pieņem vienības objektu, kas aizpildīts atļautajiem laukiem. Šo izmanto atjaunojot vienību.
  def unit_update_params
    params.require(:unit).permit(:legal_adress, :activity_location_name, :email, :phone, :bank_account, :comments, :membership_fee, :leader_id)
  end

  #Palīgfunkcija, kas pārbauda vai lietotājs ir vienības biedrs vai valdes pārstāvis
  def unit_member?
    redirect_to root_path, alert: "Nav atļauts" unless current_user.unit.id == params[:id].to_i || current_user.pklv_valde?
  end
end
