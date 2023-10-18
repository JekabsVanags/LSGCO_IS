class UsersController < ApplicationController
  before_action :authorized?
  before_action :unit_access?, only: [:create, :unit_update]

  def get
    @new_user = session[:new_user]
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.unit = current_user.unit
    password = Faker::Alphanumeric.alphanumeric
    @user.password_digest = BCrypt::Password.create(password).to_s
    @user.username = user_params[:name].capitalize + user_params[:surname].capitalize + current_user.unit.number.to_s
    if @user.save
      link = activation_path(id: @user.id, password: password)
      redirect_to root_path, notice: "User created, link: " + link
    else
      redirect_to root_path, notice: "Error."
    end
  end

  def edit
    @user = User.find(params[:id])
    @new_user = session[:new_user]
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_update_params)
      redirect_to root_path, notice: "User edited."
    else
      redirect_to root_path, notice: "Error."
    end
  end

  def unit_update
    @user = User.find(params[:id])

    if user_unit_edit_params[:unit_id]
      @user.unit = Unit.find(user_unit_edit_params[:unit_id])
      if @user.save!
        redirect_to root_path, notice: "New Unit."
      else
        redirect_to root_path, notice: "Fail."
      end
    end

    if user_unit_edit_params[:activity_statuss]
      @user.activity_statuss = user_unit_edit_params[:activity_statuss]
      if @user.save!
        redirect_to root_path, notice: "Activity statuss updated."
      else
        redirect_to root_path, notice: "Fail."
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
      redirect_to root_path, notice: "Error."
      return
    end

    if @user.save
      redirect_to edit_user_path(current_user), notice: "Parole izveidota"
    else
      redirect_to root_path, notice: "Error."
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
    params.require(:user).permit(:name, :surname, :activity_statuss, :email, :joined_date)
  end
end
