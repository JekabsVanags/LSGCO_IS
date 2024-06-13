class AddEventPublishableVolunteerScope < ActiveRecord::Migration[7.0]
  def change
    add_column :events, :publishable, :boolean
    add_column :events, :volunteer_scope, :integer, null: false
  end
end
