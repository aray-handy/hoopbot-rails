class CreateHoopEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :hoop_events do |t|
      t.string :slack_user_name, null: false
      t.string :hoop_type, null: false
      t.date :start_date, null: false
      t.date :end_date, null: true
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
