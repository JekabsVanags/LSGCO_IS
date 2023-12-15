class UsersController < ApplicationController
  before_action :authorized?
  before_action :unit_access?, only: ["create", "unit_update", "show", "promise"]
  before_action :org_access?, only: ["index"]
  before_action :unit_active?, only: ["create"]

  def new
    session[:current_tab] = "new_member"
    @user = User.new
  end

  def index
    session[:current_tab] = "user_list"
    @users = User.all
  end

  def create
    @user = User.new(user_params.except(:rank))
    @user.unit = current_user.unit
    password = Faker::Alphanumeric.alphanumeric
    @user.password_digest = BCrypt::Password.create(password).to_s

    @rank = RankHistory.new(user: @user, date_begin: Date.today, rank: user_params[:rank], current: true)

    @user.username = user_params[:name].capitalize + user_params[:surname].capitalize + current_user.unit.number.to_s
    if @user.save && @rank.save
      link = aktivizet_path(id: @user.id, password:)
      UserMailer.first_login_email(current_user, @user, link).deliver_later
      redirect_to root_path, notice: 'Biedrs pievienots'
    else
      redirect_to root_path, alert: 'Kļūda'
    end
  end

  def edit
    @user = User.find(params[:id])
    @new_user = session[:new_user]
  end

  def show
    @user = User.find(params[:id])
    @avalable_ranks = RankHistory.ranks.filter{|rank| !@user.rank_histories.where(rank: rank, current: false).present?}.keys
    @units = Unit.where(deleted_at: nil).map {|unit| [unit.full_name, unit.id]}
    @new_position = Position.new()
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_update_params)
      redirect_to root_path, notice: 'Dati atjaunoti'
    else
      redirect_to root_path, alert: 'Kļūda'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @unit = @user.unit

    if @user.update(activity_statuss: "Izstājies")
      redirect_to unit_path(@unit), notice: 'Profils dzēsts'
    else
      redirect_to unit_path(@unit), alert: 'Kļūda'
    end

  end

  def profile
    session[:current_tab] = "profile"
    @new_user = session[:new_user]
    @user = current_user
    @events = @user.available_events.sort_by(&:date_from)

  end

  def unit_update
    @user = User.find(params[:id])

    if user_unit_edit_params[:unit_id]
      @user.unit = Unit.find(user_unit_edit_params[:unit_id])
      if @user.save!
        redirect_to user_path(@user), notice: 'Vienība nomainīta'
      else
        redirect_to user_path(@user), alert: 'Kļūda'
      end
    end

    if user_unit_edit_params[:activity_statuss]
      @user.activity_statuss = user_unit_edit_params[:activity_statuss]
      if @user.save!
        redirect_to user_path(@user), notice: 'Aktivitātes statuss nomainīts'
      else
        redirect_to user_path(@user), alert: 'Kļūda'
      end
    end

    if user_unit_edit_params[:rank]
    @rank = RankHistory.new(user: @user, date_begin: Date.today, rank: user_unit_edit_params[:rank], current: true)

    if @user.rank_histories.where(current: true).update(current: false) && @rank.save!
      redirect_to user_path(@user), notice: 'Pakāpe nomainīta'
    else
      redirect_to user_path(@user), alert: 'Kļūda'
    end
    end
  end

  def promise
    @user = User.find(params[:id])

    if @user.rank_histories.where(current: true).update(date_of_oath: params[:promise_date] || Date.today)
      redirect_to user_path(@user), notice: 'Solījums atzīmēts'
    else
      redirect_to user_path(@user), alert: 'Kļūda'
    end
  end

  def password_update
    @user = User.find(params[:id])
    path = session[:new_user] == true ? aktivizet_path(@user.id, params[:old_password]) : edit_user_path(@user.id)
    success_notice = session[:new_user] == true ? "Parole izveidota" : "Parole atjaunota"

    if params[:password_digest] != params[:repeat_password]
      redirect_to path, notice: 'Paroles nesakrīt'
      return
    end

    if @user.authenticate(params[:old_password])
      @user.password_digest = BCrypt::Password.create(params[:password_digest]).to_s
    else
      if session[:new_user] == true
      session.clear
      redirect_to root_path, notice: 'Nepareiza parole'
      else
      redirect_to edit_user_path(current_user), notice: 'Nepareiza pašreizējā parole'
      end
      return
    end

    if @user.save
      redirect_to edit_user_path(current_user), notice: success_notice
    else
      redirect_to path, alert: 'Kļūda'
    end
  end

  def send_password_reset
    @user = User.find(params[:id])
    password = Faker::Alphanumeric.alphanumeric
    @user.password_digest = BCrypt::Password.create(password).to_s
    @user.save!

    @link = atjaunot_path(id: @user.id, password:)

    UserMailer.password_reset_email(@user, @link).deliver_later
    redirect_to user_path(@user), notice: "Epasts ar paroles atjaunošanas instrukcijām nosūtīts"
  end

  def resignation
    @user = @current_user

    @link = user_path(@user.id)

    if @user.update(activity_statuss: "Neaktīvs")
      if @user.personal_information.present?
        @user.personal_information.destroy
      end
      UserMailer.user_resignation_email(@user, @user.unit.unit_leader, @link).deliver_later
      redirect_to edit_user_path(current_user), notice: "Jūsu iesniegums ir nosūtīts"
    else
      redirect_to edit_user_path(current_user), alert: 'Kļūda'
    end
  end

  protected

  def user_unit_edit_params
    params.permit(:activity_statuss, :unit_id, :rank)
  end

  def user_update_params
    params.require(:user).permit(:name, :surname, :phone, :email, :birth_date, :sex, :agreed_to_data_collection, :volunteer)
  end

  def user_params
    params.require(:user).permit(:name, :surname, :activity_statuss, :email, :joined_date, :rank)
  end
end
