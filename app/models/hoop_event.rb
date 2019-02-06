class HoopEvent < ApplicationRecord
  def start_time
    self.start_date.beginning_of_day
  end

  def end_time
    self.end_date.beginning_of_day
  end

  def name
    "#{slack_user_name} is #{hoop_type}"
  end
end
