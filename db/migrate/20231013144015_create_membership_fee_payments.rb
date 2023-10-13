class CreateMembershipFeePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :membership_fee_payments do |t|
      t.date :date
      t.decimal :amount
      t.references :user_recorded, null: false, foreign_key: true
      t.references :user_payed, null: false, foreign_key: true
      t.references :unit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
