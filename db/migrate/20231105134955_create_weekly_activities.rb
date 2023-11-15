class CreateWeeklyActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :weekly_activities do |t|
      t.references :unit, null: false, foreign_key: true
      t.integer :day, null: false
      t.time :time, null: false
      t.integer :rank

      t.timestamps
    end
  end
end
