class CreateEventRegistrations < ActiveRecord::Migration[7.0]
  def change
    create_table :event_registrations do |t|
      t.references :user, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :role, null: false
      t.string :position
      t.boolean :private_info_permission, null: false, default: false

      t.timestamps
    end
  end
end
