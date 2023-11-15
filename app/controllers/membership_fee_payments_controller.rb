class MembershipFeePaymentsController < ApplicationController
  before_action :unit_access?, :authorized?

  def create
    @user = User.find(membership_fee_payment_params[:user_payed])
    @payment = MembershipFeePayment.new({ amount: membership_fee_payment_params[:amount], date: membership_fee_payment_params[:date], user_payed: @user, user_recorded: current_user, unit: current_user.unit })

    @recalculated_bilance = @user.membership_fee_bilance + @payment.amount

    if @payment.save! && @user.update(membership_fee_bilance: @recalculated_bilance)
      redirect_to list_membership_fee_payment_path(@user), notice: "Maksājums reģistrēts"
    else
      redirect_to list_membership_fee_payment_path(@user), notice: "Kļūda"
    end
  end

  def list
    @user = User.find(params[:id])
    @payments = MembershipFeePayment.where(user_payed: params[:id]).order(created_at: :desc)
    @new_payment = MembershipFeePayment.new(date: Date.today)
  end

  def destroy
    @payment = MembershipFeePayment.find(params[:id])
    @user = @payment.user_payed
    @reverse = MembershipFeePayment.new({ date: Date.today, amount: -(@payment.amount), user_payed: @payment.user_payed, user_recorded: current_user, unit: @payment.unit, recalled: true })

    @recalculated_bilance = @user.membership_fee_bilance + @reverse.amount

    if @reverse.save! &&
       current_user == @payment.user_recorded &&
       @payment.recalled == false &&
       @payment.update(recalled: true) &&
       @user.update(membership_fee_bilance: @recalculated_bilance)
      redirect_to list_membership_fee_payment_path(@user), notice: "Maksājums atsaukts"
    else
      redirect_to list_membership_fee_payment_path(@user), notice: "Kļūda"
    end
  end

  private

  def membership_fee_payment_params
    params.require(:membership_fee_payment).permit(:user_payed, :date, :amount)
  end
end
