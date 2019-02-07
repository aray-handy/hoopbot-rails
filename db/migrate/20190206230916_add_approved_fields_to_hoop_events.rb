class AddApprovedFieldsToHoopEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :hoop_events, :approver, :string
    add_column :hoop_events, :approved, :boolean, default: false
  end
end
