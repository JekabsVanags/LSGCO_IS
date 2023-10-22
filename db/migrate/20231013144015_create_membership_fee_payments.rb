class CreateMembershipFeePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :membership_fee_payments do |t|
      t.date :date, null: false
      t.decimal :amount, null: false
      t.references :user_recorded, null: false, foreign_key: { to_table: :users }
      t.references :user_payed, null: false, foreign_key: { to_table: :users }
      t.references :unit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
