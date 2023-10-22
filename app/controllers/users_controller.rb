class UsersController < ApplicationController
  before_action :authorized?
  before_action :unit_access?, only: [:create, :unit_update]

  def get
    @new_user = session[:new_user]
    @user = current_user
    @events = @user.unit.get_actual_events(@user.rank)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.except(:rank))
    @user.unit = current_user.unit
    password = Faker::Alphanumeric.alphanumeric
    @user.password_digest = BCrypt::Password.create(password).to_s

    @rank = RankHistory.new(user: @user, date_begin: Date.today, rank: user_params[:rank], current: true)

    @user.username = user_params[:name].capitalize + user_params[:surname].capitalize + current_user.unit.number.to_s
    if @user.save && @rank.save
      link = activation_path(id: @user.id, password: password)
      UserMailer.first_login_email(current_user, @user, link).deliver_later
      redirect_to root_path, notice: "Biedrs pievienots"
    else
      redirect_to root_path, notice: "Kļūda"
    end
  end

  def edit
    @user = User.find(params[:id])
    @new_user = session[:new_user]
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_update_params)
      redirect_to root_path, notice: "Dati atjaunoti"
    else
      redirect_to root_path, notice: "Kļūda"
    end
  end

  def unit_update
    @user = User.find(params[:id])

    if user_unit_edit_params[:unit_id]
      @user.unit = Unit.find(user_unit_edit_params[:unit_id])
      if @user.save!
        redirect_to root_path, notice: "Vienība nomainīta"
      else
        redirect_to root_path, notice: "Kļūda"
      end
    end

    if user_unit_edit_params[:activity_statuss]
      @user.activity_statuss = user_unit_edit_params[:activity_statuss]
      if @user.save!
        redirect_to root_path, notice: "Aktivitātes statuss nomainīts"
      else
        redirect_to root_path, notice: "Kļūda"
      end
    end
  end

  def password_update
    @user = User.find(params[:id])

    if params[:password_digest] != params[:repeat_password]
      redirect_to activation_path(@user.id, params[:old_password]), notice: "Paroles nesakrīt"
      return
    end

    if @user.authenticate(params[:old_password])
      @user.password_digest = BCrypt::Password.create(params[:password_digest]).to_s
    else
      session.clear
      redirect_to root_path, notice: "Kļūda"
      return
    end

    if @user.save
      redirect_to edit_user_path(current_user), notice: "Parole izveidota"
    else
      redirect_to root_path, notice: "Kļūda"
    end
  end

  protected

  def user_unit_edit_params
    params.require(:user).permit(:activity_statuss, :unit_id)
  end

  def user_update_params
    params.require(:user).permit(:name, :surname, :phone, :email, :birth_date, :sex, :agreed_to_data_collection)
  end

  def user_params
    params.require(:user).permit(:name, :surname, :activity_statuss, :email, :joined_date, :rank)
  end
end
