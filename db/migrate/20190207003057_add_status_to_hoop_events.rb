class AddStatusToHoopEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :hoop_events, :status, :string, null: false, default: "pending"
  end
end
