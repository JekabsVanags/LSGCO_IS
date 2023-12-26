class ReportsController < ApplicationController
  include ApplicationHelper

  #Pārbaudam vai lietotājs ir autorizējies un vai tam ir pieteikamas piekļuves
  before_action :authorized?, :unit_access?
  before_action :org_access?, only: ["member_report"]

  def unit_report
    session[:current_tab] = "unit_report" #Iestatam, ka izvēlnes aktīvā sekcija ir vienību atskaite
    if params[:id] #Ja ir zināma vienība par ko vācam atskaiti, iegūstam datus
      @unit = Unit.find(params[:id])
      @weekly_activities = @unit.weekly_activities
      @users = @unit.users.includes(:positions)
      @events = (@unit.events.unscoped + @unit.event_invites).uniq
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
    @users = User.all
    @member_report = generate_member_report(@users)
    @rank_report = count_rank_members(@users)

    respond_to do |format|
      format.html
      format.xlsx { response.headers["Content-Disposition"] = "attachment; filename=lsgco_biedru_atskaite_#{Date.today}.xlsx" }
    end
  end

  private

  def generate_payment_summary(unit)
    users_with_payments = unit.users.includes(:payed_fees)

    payment_summary = users_with_payments.map do |user|
      #Katram lietotājam izveidojam atsevišķu atskaiti
      user_summary = []

      (1..12).each do |month| #Katram mēnesim atrodam kāda maksājumu summa katrā mēnesī, saglabājam masīvā vieglai apstrādei
        monthly_summary = user.payed_fees
                              .where("EXTRACT(MONTH FROM date) = ?", month)
                              .where("EXTRACT(YEAR FROM date) = ?", Date.today.year)
                              .sum(:amount)

        user_summary[month - 1] = monthly_summary
      end

      #Par katru lietotāju atgriežam sekojošos datus
      {
        id: user.id,
        name: user.name,
        surname: user.surname,
        bilance: user.membership_fee_bilance,
        payed_total: user_summary.sum, #Kopējā maksājumu summa
        summary: user_summary,  #Maksājumi pa mēnešiem
      }
    end

    payment_summary
  end

  def generate_org_fee(payments, unit)
    #Aprēķinam atsevišķās maksājumu likmes
    org_fee = Unit.where({ number: 0 }).first.membership_fee
    total_fee = org_fee + unit.membership_fee

    payments.reduce(0) do |sum, payment| #Visus maksājumus pārveidojam par aprēķinātu summu.
      #Formula veidota, lai no kopēja maksājuma aprēķinātu cik daudz jāmaksā organizācijai.
      #Reizinam organizācijas dalības maksu ar mēnešu skaitu par ko maksāts, ko iegūstam
      #dalot samaksāto ar to cik jāmaksā katru mēnesi kopā. Neieskaitam mēnešus, kas maksāti avansā.
      sum += org_fee * ((payment[:payed_total] - payment[:bilance]) / total_fee)
    end
  end

  def generate_member_report(users)
    #Lietotāju statistika
    active_users = users.where.not(activity_statuss: "Izstājies").count
    users_this_year = users.where.not(activity_statuss: "Izstājies").where("joined_date >= ? AND joined_date <= ?", Date.current.beginning_of_year, Date.current.end_of_year).count

    #Vienību statistika
    active_units = Unit.where.not(number: 0).where(deleted_at: nil).count
    inactive_units = Unit.where.not(number: 0).where.not(deleted_at: nil).count
    units_this_year = Unit.where.not(number: 0).where("created_at >= ? AND created_at <= ?", Date.current.beginning_of_year, Date.current.end_of_year).count

    #Atgriežam datus
    {
      member_count: active_users,
      unit_count: active_units,
      inactive_count: inactive_units,
      new_members_count: users_this_year,
      new_unit_count: units_this_year,
    }
  end

  def count_rank_members(users)
    #Katrai pakāpei izveidojam statistiku, cik lietotāji ar aktīvu šo pakāpi, cik daudz ar solijumu
    ranks_short.map do |rank|
      members = users.joins(:rank_histories).where.not(activity_statuss: "Izstājies").where(rank_histories: { current: true, rank: rank })
      with_promise = members.where.not(rank_histories: { date_of_oath: nil }).count

      { rank: rank,
        count: members.count,
        promise: with_promise }
    end
  end
end
