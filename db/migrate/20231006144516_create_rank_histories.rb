class CreateRankHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :rank_histories do |t|
      t.integer :rank, null: false
      t.references :user, null: false, foreign_key: true
      t.boolean :current, null: false, default: true
      t.date :date_begin, null: false
      t.date :date_of_oath

      t.timestamps
    end
  end
end
