class Refactoring < ActiveRecord::Migration[7.0]
  def change
    add_column :units, :unit_leader_id, :bigint
    add_foreign_key :units, :users, column: :unit_leader_id

    add_column :membership_fee_payments, :user_statuss, :integer
    add_column :membership_fee_payments, :org_fee, :decimal

    add_column :events, :registration_till, :date
  end
end
