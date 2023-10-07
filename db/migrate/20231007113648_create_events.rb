class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.references :unit, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.date :date_from, null: false
      t.date :date_to
      t.integer :event_type, null: false
      t.integer :necessary_volunteers
      t.integer :registered_volunteers, default: 0
      t.integer :max_participants
      t.integer :registered_participants, default: 0
      t.date :deleted_at

      t.timestamps
    end
  end
end
