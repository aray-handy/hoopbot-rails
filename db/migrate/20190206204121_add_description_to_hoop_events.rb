class AddDescriptionToHoopEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :hoop_events, :description, :string
  end
end
