class PersonalInformationController < ApplicationController
  before_action :authorized?

  def new
    @info = PersonalInformation.new()
    @info.health_issues = "-"
    @info.medication_during_event = "-"
    @info.psychological_features = "-"
    @info.diet = "-"
  end

  def create
    @info = PersonalInformation.new(personal_information_params)
    @info.user = current_user
    if @info.save
      redirect_to aptaujas_lapa_path, notice: "Aptaujas lapa saglabāta."
    else
      redirect_to aptaujas_lapa_path, alert: "Kļūda"
    end
  end

  def edit
    @info = current_user.personal_information
  end

  def update
    @info = current_user.personal_information
    if @info.update(personal_information_params)
      redirect_to aptaujas_lapa_path, notice: "Aptaujas lapa atjaunota."
    else
      redirect_to aptaujas_lapa_path, alert: "Kļūda"
    end
  end

  def destroy
    @info = current_user.personal_information
    if @info.delete
      redirect_to aptaujas_lapa_path, notice: "Aptaujas lapa dzēsta."
    else
      redirect_to aptaujas_lapa_path, alert: "Kļūda"
    end
  end

  def show
    session[:current_tab] = "private_info"
    @info = current_user.personal_information
  end

  def display
    @registration = EventRegistration.find(params[:id])
    @user = @registration.user
    @info = @user.personal_information
  end

  protected

  def personal_information_params
    params.require(:personal_information).permit(PersonalInformation.column_names - ["created_at", "updated_at"])
  end
end
