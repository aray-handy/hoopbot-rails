class HoopbotController < ApplicationController
  def create
    CommandWorker.perform_async(command_params.to_h)

    render json: { response_type: "in_channel" }, status: :created
  end

  private

  def valid_slack_token?
    params[:token] == ENV["SLACK_SLASH_COMMAND_TOKEN"]
  end

  def command_params
    params.permit(:user_name, :text, :token, :response_url)
  end
end
