class ReportsController < ApplicationController
  #Pirms ļaujam lietotājam piekļūt resursam pārbaudam vai lietotājs ir autorizējies un vai tam ir pieteikamas piekļuves
  before_action :unit_access?, :authorized?
  before_action :org_access?, only: ["member_report"]

  def unit_report
    session[:current_tab] = "unit_report" #Iestatam, ka izvēlnes aktīvā sekcija ir vienību atskaite
    if params[:id] #Ja ir zināma vienība par ko vācam atskaiti, iegūstam datus
      @unit = Unit.find(params[:id])
      @weekly_activities = @unit.weekly_activities
      @users = @unit.users.includes(:positions)
      @events = (@unit.events.unscoped + @unit.event_invites).uniq
      @report = generate_unit_report_data
      @payments = generate_payment_summary(@unit)
      @org_fee_bilance = generate_org_fee(@payments, @unit)
      @positions = @unit.positions.includes(:user)

      respond_to do |format|
        format.html
        format.xlsx { response.headers["Content-Disposition"] = "attachment; filename=#{@unit.city}_#{@unit.number}_vienibas_biedru_atskaite_#{Date.today}.xlsx" }
      end
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

    respond_to do |format|
      format.html
      format.xlsx { response.headers["Content-Disposition"] = "attachment; filename=lsgco_biedru_atskaite_#{Date.today}.xlsx" }
    end
  end

  private

  def generate_payment_summary(unit)
    users_with_payments = unit.users.includes(:payed_fees)

    payment_summary = users_with_payments.map do |user|

      if user.activity_statuss == "Izstājies" || user.activity_statuss == "Neaktīvs"
        month_left = Date(user.updated_at).month

      end
      user_summary = []

      (1..12).each do |month|
        monthly_summary = user.payed_fees
                              .where("EXTRACT(MONTH FROM date) = ?", month)
                              .sum(:amount)

        user_summary[month-1] = monthly_summary
      end

       {
        id: user.id,
        name: user.name,
        surname: user.surname,
        bilance: user.membership_fee_bilance,
        payed_total: user_summary.sum,
        summary: user_summary
      }
    end

    payment_summary
  end

  def generate_org_fee(payments, unit)
    org_fee = Unit.where({number: 0}).first.membership_fee
    total_fee = org_fee + unit.membership_fee
    payments.reduce(0) do |sum, payment|
      sum += org_fee * (payment[:payed_total] / total_fee)
    end
  end



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
