class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :city
      t.integer :number
      t.string :legal_adress
      t.string :activity_location_name
      t.string :email
      t.string :phone
      t.text :comments
      t.text :bank_account
      t.date :deleted_at
      t.decimal :membership_fee

      t.timestamps
    end

    add_reference :users, :units, index: true
  end
end
