class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :city, null: false
      t.integer :number, null: false
      t.string :legal_adress, null: false
      t.string :activity_location_name
      t.string :email
      t.string :phone
      t.text :comments
      t.text :bank_account, null: false
      t.date :deleted_at
      t.decimal :membership_fee

      t.timestamps
    end

    add_reference :users, :unit, index: true
  end
end
