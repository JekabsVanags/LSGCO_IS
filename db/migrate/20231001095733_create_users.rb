class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :surname, null: false
      t.string :phone
      t.string :email
      t.integer :activity_statuss, null: false
      t.decimal :membership_fee_bilance, null: false, default: 0
      t.date :joined_date, null: false
      t.date :birth_date
      t.integer :sex
      t.string :password_digest
      t.integer :permission_level, null: false, default: 0
      t.boolean :agreed_to_data_collection
      t.boolean :volunteer, default: false

      t.timestamps
    end
  end
end
