class ReportsController < ApplicationController
  #Pirms ļaujam lietotājam piekļūt resursam pārbaudam vai lietotājs ir autorizējies un vai tam ir pieteikamas piekļuves
  before_action :unit_access?, :authorized?
  before_action :org_access?, only: ["member_report"]

  def unit_report
    session[:current_tab] = "unit_report" #Iestatam, ka izvēlnes aktīvā sekcija ir vienību atskaite

    if params[:id] #Ja ir zināma vienība par ko vācam atskaiti, iegūstam datus
      @unit = Unit.find(params[:id])
      @users = @unit.users
      @report = generate_unit_report_data
    else #Citādi iegūstam sarakstu ar vienībām priekš izvēlnes, kas neiekļauj administrācijas vienību (ar ciparu 0)
      @units = Unit.where(deleted_at: nil).map do |unit|
        unless unit.number == 0
          [unit.full_name, unit.id]
        end
      end.compact
    end
  end

  def member_report
    session[:current_tab] = "member_report"  #Iestatam, ka izvēlnes aktīvā sekcija ir vienību atskaite
    @report = generate_mamber_report_data
    @users = User.all
  end

  private

  def generate_mamber_report_data
    year_new_users = User.where(created_at: Time.now.beginning_of_year..Time.now.end_of_year).count

    year_new_ranks = RankHistory.ranks.map { |rank|
      RankHistory.where.not(date_of_oath: nil).where(created_at: Time.now.beginning_of_year..Time.now.end_of_year, rank: rank).count
    }

    return { year_new_ranks: year_new_ranks, year_new_users: year_new_users }
  end

  def generate_unit_report_data
    test = 2
  end
end
