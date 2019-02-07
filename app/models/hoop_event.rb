class HoopEvent < ApplicationRecord
  def start_time
    self.start_date.beginning_of_day
  end

  def end_time
    self.end_date.beginning_of_day
  end

  def name
    if description.present?
      "#{slack_user_name} is #{hoop_type} - #{description}"
    else
      "#{slack_user_name} is #{hoop_type}"
    end
  end

  def approve!
    update_attributes!(approved: true)
  end
end
