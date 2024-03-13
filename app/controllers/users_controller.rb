class UsersController < ApplicationController
  #Pārbauda vai lietotājs ir autorizējies un vai tam ir pieteikamas piekļuves
  before_action :authorized?
  before_action :unit_access?, only: ["create", "new", "unit_update", "show", "promise", "empower_user", "depower_user"]
  before_action :org_access?, only: ["index"]   #Tikai var apskatīties sarakstu ar visiem lietotājiem
  before_action :unit_active?, only: ["create"]   #Veidojam jaunu lietotāju tikai aktīvām vienībām

  def new #Tukšs lietotāja objekts ar ko aizpildīt jauna lietotāja formu
    session[:current_tab] = "new_member"  #Iestatam, ka izvēlnes aktīvā sekcija ir jauna lietotāja pievienošana
    @user = User.new
  end

  def index #Visi sistēmas lietotāji
    session[:current_tab] = "user_list"  #Iestatam, ka izvēlnes aktīvā sekcija ir biedru saraksts
    @users = User.all
  end

  def create #Izveido jaunu lietotāju
    @user = User.new(user_params.except(:rank)) #Aizpildam ar vērtībām izņemot rank, ko izmanto zemāk, lietotāja vienība sakrīt ar tā veidotāja vienību
    @user.unit = current_user.unit 
    password = rand(36**20).to_s(36)  #Pagaidu randomizēta parole
    @user.password_digest = BCrypt::Password.create(password).to_s #Šifrēšana

    @rank = RankHistory.new(user: @user, date_begin: Date.today, rank: user_params[:rank], current: true) #Lietotāja pakāpes vēsture

    @user.username = user_params[:name].capitalize + user_params[:surname].capitalize + current_user.unit.number.to_s #Lietotāja lietotājvārda izveide (piem. VārdsUzvārds29)
    if @user.save && @rank.save #Ja kļūda saglabājot lietotāju un pakāpi, paziņo
      #Saite uz paroles atiestatīšanu, epasta nosūtīšana
      link = aktivizet_path(id: @user.id, password:) 
      UserMailer.first_login_email(current_user, @user, link).deliver_later
      redirect_to root_path, notice: 'Biedrs pievienots'
    else
      redirect_to root_path, alert: 'Kļūda'
    end
  end

  def edit #Lietotāja objekts ar ko aizpildīt lietotāja datu atjaunošanas formu
    @user = User.find(params[:id])
    @new_user = session[:new_user]
  end

  def show #Lietotāja dati vienības priekšnieka apskatei
    @user = User.find(params[:id])
    @avalable_ranks = RankHistory.ranks.filter{|rank| !@user.rank_histories.where(rank: rank, current: false).present?}.keys #Pakāpes, kurās lietotājs nav bijis
    @units = Unit.where(deleted_at: nil).map {|unit| [unit.full_name, unit.id]} #Organizācijas vienību saraksts
    @new_position = Position.new() #Tukšs jauna amata objekts
  end

  def update #atjauno lietotāju, ja neizdodas saglabāt Paziņo kļūdu.
    @user = User.find(params[:id])

    if @user.update(user_update_params)
      redirect_to root_path, notice: 'Dati atjaunoti'
    else
      redirect_to root_path, alert: 'Kļūda'
    end
  end

  def destroy #Nestingrā dzēšana lietotājam, ja neizdodas nomainīt statusu Paziņo kļūdu
    @user = User.find(params[:id])
    @unit = @user.unit

    if @user.update(activity_statuss: "Izstājies")
      redirect_to unit_path(@unit), notice: 'Profils dzēsts'
    else
      redirect_to unit_path(@unit), alert: 'Kļūda'
    end

  end

  def profile #Lietotāja dati lietotāja apskatei
    session[:current_tab] = "profile"  #Iestatam, ka izvēlnes aktīvā sekcija ir profils
    @new_user = session[:new_user]
    @user = current_user
    @events = @user.available_events.sort_by(&:date_from) #Lietotāja aktuālie pasākumi

  end

  def unit_update #Lietotāja atjaunošana, ko veic vienības priekšnieks
    @user = User.find(params[:id])

    if user_unit_edit_params[:unit_id] #Maina vienību, ja tāda norādīta, Paziņo ja kļūda
      @user.unit = Unit.find(user_unit_edit_params[:unit_id])
      if @user.save!
        redirect_to user_path(@user), notice: 'Vienība nomainīta'
      else
        redirect_to user_path(@user), alert: 'Kļūda'
      end
    end

    if user_unit_edit_params[:activity_statuss] #Maina aktivitātes statusu, ja tas norādīts, Paziņo ja kļūda
      @user.activity_statuss = user_unit_edit_params[:activity_statuss]
      if @user.save!
        redirect_to user_path(@user), notice: 'Aktivitātes statuss nomainīts'
      else
        redirect_to user_path(@user), alert: 'Kļūda'
      end
    end

    if user_unit_edit_params[:rank] #Mainam pakāpi ja tā norādita, Paziņo ja kļūda
    @rank = RankHistory.new(user: @user, date_begin: Date.today, rank: user_unit_edit_params[:rank], current: true) #Izveidojam jaunu pašreizējo pakāpes vēstures objektu.

    if @user.rank_histories.where(current: true).update(current: false) && @rank.save! #Vecajai pakāpes vēsturei noņemam pašreizējās statusu un saglabājam jauno, Paziņo
      redirect_to user_path(@user), notice: 'Pakāpe nomainīta'
    else
      redirect_to user_path(@user), alert: 'Kļūda'
    end
    end
  end

  def promise #Reģistrējam pašreizējās pakāpes solījuma datumu, ja neizdodas Paziņo kļūdu
    @user = User.find(params[:id])

    if @user.rank_histories.where(current: true).update(date_of_oath: params[:promise_date] || Date.today)
      redirect_to user_path(@user), notice: 'Solījums atzīmēts'
    else
      redirect_to user_path(@user), alert: 'Kļūda'
    end
  end

  def password_update #Lietotāja paroles atiestatīšana
    @user = User.find(params[:id])
    #Atkarībā no tā vai lietotājs ir jauns atšķiras saite uz ko pārvirzīt to un ar kādu paziņojumu
    path = session[:new_user] == true || session[:password_reset] == true ? aktivizet_path(@user.id, params[:old_password]) : edit_user_path(@user.id)
    success_notice = session[:new_user] == true ? "Parole izveidota" : "Parole atjaunota"

    if params[:password_digest] != params[:repeat_password] #Pārbaude vai 2x ievadītā parole sakrīt, ja nē pārvirzam ar paziņojumu
      redirect_to path, notice: 'Paroles nesakrīt'
      return
    end

    if @user.authenticate(params[:old_password]) #Ja vecās paroles parametrs sakrīt ar lietotāja paroli šifrējam jauno paroli un atjauno.
      @user.password_digest = BCrypt::Password.create(params[:password_digest]).to_s
    else #Citādi Paziņo. Jauns lietotājs tiek pārvirzīts uz sākuma skatu, reģistrējies uz lietotāja datu atjaunošanu
      if session[:new_user] == true
      session.clear
      redirect_to root_path, notice: 'Nepareiza parole'
      else
      redirect_to edit_user_path(current_user), notice: 'Nepareiza pašreizējā parole'
      end
      return
    end

    if @user.save #Saglabājam jauno paroli un Paziņo
      redirect_to edit_user_path(current_user), notice: success_notice
    else
      redirect_to path, alert: 'Kļūda'
    end
  end

  def send_password_reset #Paroles atiestatīšanas epasta nosūtīšana lietotājam
    @user = User.find(params[:id])
    #atjauno lietotāja paroli uz pagaidu randomizētu paroli
    password = rand(36**20).to_s(36)
    @user.password_digest = BCrypt::Password.create(password).to_s
    @user.save!

    @link = atjaunot_path(id: @user.id, password:) #Saite uz paroles atiestatīšanas skatu

    #Nosūtam epastu un Paziņo par to
    UserMailer.password_reset_email(@user, @link).deliver_later 
    redirect_to user_path(@user), notice: "Epasts ar paroles atjaunošanas instrukcijām nosūtīts"
  end

  def resignation #Lietotāja izstāšanās iesniegums
    @user = @current_user

    @link = user_path(@user.id) #Links uz lietotāja biedra paneli

    if @user.update(activity_statuss: "Neaktīvs")
      #Ja izdodas atjaunot statusu dzēšam aptaujas lapu ja tāda ir un nosūtam epastu vienības priekšniekam.
      if @user.personal_information.present?
        @user.personal_information.destroy
      end
      UserMailer.user_resignation_email(@user, @user.unit.unit_leader, @link).deliver_later
      redirect_to edit_user_path(current_user), notice: "Jūsu iesniegums ir nosūtīts"
    else
      redirect_to edit_user_path(current_user), alert: 'Kļūda'
    end
  end

  def empower_user
    permission_level = params[:permission]

   if permission_level == "pklv_vaditajs" && @current_user.leader_for_unit || permission_level == "pklv_valde" && @current_user.permission_level == "pklv_valde"
      @user = User.find(params[:id])
      if @user.update(permission_level: permission_level)
        redirect_to user_path(params[:id]), notice: 'Piekļuve piešķirta'
      else
        redirect_to user_path(params[:id]), alert: 'Kļūda'
      end
    else
      redirect_to user_path(params[:id]), alert: 'Trūkst piekļuves'
    end
  end

  def depower_user
    @user = User.find(params[:id])
    permission = "pklv_biedrs"

    if @user.leader_for_unit
      permission = "pklv_vaditajs"
    end

    if @user.update(permission_level: permission)
      redirect_to user_path(params[:id]), alert: 'Piekļuve samazināta'
    else
      redirect_to user_path(params[:id]), alert: 'Kļūda'
    end
  end

  protected

   #Pieņem lietotāja objektu, kas aizpildīts atļautajiem laukiem. Šo izmanto veicot vienības priekšnieka darbības ar lietotāju.
  def user_unit_edit_params
    params.permit(:activity_statuss, :unit_id, :rank)
  end

   #Pieņem lietotāja objektu, kas aizpildīts atļautajiem laukiem. Šo izmanto atjaunojot lietotāju.
  def user_update_params
    params.require(:user).permit(:name, :surname, :phone, :email, :birth_date, :sex, :agreed_to_data_collection, :volunteer)
  end

  #Pieņem lietotāja objektu, kas aizpildīts atļautajiem laukiem. Šo izmanto taisot jaunu lietotāju.
  def user_params
    params.require(:user).permit(:name, :surname, :activity_statuss, :email, :joined_date, :rank)
  end
end
