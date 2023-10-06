class CreatePersonalInformations < ActiveRecord::Migration[7.0]
  def change
    create_table :personal_informations do |t|
      t.references :user, null: false, foreign_key: trues
      t.string :address 
      t.string :emergency_contact_number
      t.integer :emergency_contact_relationship
      t.text :health_issues
      t.text :medication_during_event
      t.text :psychological_features
      t.text :diet

      t.timestamps
    end
  end
end
