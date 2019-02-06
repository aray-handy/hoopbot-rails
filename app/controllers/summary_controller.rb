class SummaryController < ApplicationController
  module Types
    WEEK = "week"
    MONTH = "month"
  end

  def show
    @type = params[:type]
    @user_name = params[:slack_username]
    @hoops = HoopEvent.where("start_date > ? AND end_date < ?", start_of_period, end_of_period)
    if @user_name
      @hoops = @hoops.where(slack_user_name: @user_name)
    end
    @events = build_events(@hoops)

    render "#{@type}"
  end

  private

  def build_events(hoops)
    result = []

    hoops.each do |h|
      event = OpenStruct.new
      event.name = "#{h.slack_user_name} OOO(#{h.hoop_type})"
      result << event
    end
  end

  def start_of_period
    if start_date
      start_date.send("beginning_of_#{@type}".to_sym)
    else
      DateTime.now.send("beginning_of_#{@type}".to_sym)
    end
  end

  def end_of_period
    if start_date
      start_date.send("end_of_#{@type}".to_sym)
    else
      DateTime.now.send("end_of_#{@type}".to_sym)
    end
  end

  def start_date
    Date.parse(params[:start_date], "%Y-%m-%d")
  rescue
    nil
  end
end
