class CreateInvites < ActiveRecord::Migration[7.0]
  def change
    create_table :invites do |t|
      t.references :unit, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :rank, null: false

      t.timestamps
    end
  end
end
