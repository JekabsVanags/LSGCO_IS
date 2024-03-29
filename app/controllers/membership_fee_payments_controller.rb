class MembershipFeePaymentsController < ApplicationController
  #Pārbauda vai lietotājs ir autorizējies un ar vienības piekļuves līmeni vai augstāk
  before_action :authorized?, :unit_access?

  def create #Izveido jaunu maksājumu
    @user = User.find(membership_fee_payment_params[:user_payed])

    #Aprēķinam cik no naudas iet organizācijai
    @organization_fee = (Unit.where(number: 0).first).membership_fee
    @fee = @user.unit.membership_fee + @organization_fee
    @org_fee = @user.activity_statuss != "Daļēji aktīvs" ? (membership_fee_payment_params[:amount].to_i / @fee) * @organization_fee : membership_fee_payment_params[:amount]

    @payment = MembershipFeePayment.new({ amount: membership_fee_payment_params[:amount], date: membership_fee_payment_params[:date], user_payed: @user, user_recorded: current_user, unit: current_user.unit, org_fee: @org_fee, user_statuss: @user.activity_statuss })

    @recalculated_bilance = @user.membership_fee_bilance + @payment.amount #Izmaina bilanci attiecīgi maksājumam

    if @payment.save! && @user.update(membership_fee_bilance: @recalculated_bilance) #Saglabā maksājumu un lietotāju, ja kļūda, paziņo
      redirect_to list_membership_fee_payment_path(@user), notice: "Maksājums reģistrēts"
    else
      redirect_to list_membership_fee_payment_path(@user), alert: "Kļūda"
    end
  end

  def list #Uzsaita lietotāja maksājumus
    @user = User.find(params[:id])
    @payments = MembershipFeePayment.where(user_payed: params[:id]).order(date: :desc)
    @new_payment = MembershipFeePayment.new(date: Date.today) #Tukš maksājuma objekts
  end

  def destroy #"Dzēš" kļūdainu maksājumu
    @payment = MembershipFeePayment.find(params[:id])
    @user = @payment.user_payed
    #Izveido jaunu maksājumu kas ir pretējs tam ko atceļam.
    @reverse = MembershipFeePayment.new({ date: Date.today, amount: -(@payment.amount), user_payed: @payment.user_payed, user_recorded: current_user, unit: @payment.unit, recalled: true, org_fee: -(@payment.org_fee), user_statuss: (@payment.user_statuss) })

    @recalculated_bilance = @user.membership_fee_bilance + @reverse.amount #Atjauno lietotāja bilanci attiecīgi atceltajam maksājumam

    #Tikai lietotājs kas ir reģistrējis maksājumu to var atcelt, atjauno lietotāju, atcelto maksājumu un saglabājam jauno, ja kļūda paziņo
    if @reverse.save! &&
       current_user == @payment.user_recorded &&
       @payment.recalled == false &&
       @payment.update(recalled: true) &&
       @user.update(membership_fee_bilance: @recalculated_bilance)
      redirect_to list_membership_fee_payment_path(@user), notice: "Maksājums atsaukts"
    else
      redirect_to list_membership_fee_payment_path(@user), alert: "Kļūda"
    end
  end

  private

  #Pieņem biedra naudas maksājuma objektu ar atļautajiem laukiem
  def membership_fee_payment_params
    params.require(:membership_fee_payment).permit(:user_payed, :date, :amount)
  end
end
