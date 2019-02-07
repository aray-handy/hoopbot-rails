class CallbackController < ApplicationController
  def create
    if parsed_payload[:type] == "dialog_submission"
      command_params = {
        type: submission[:type],
        start_date: submission[:start_date],
        end_date: submission[:end_date],
        description: submission[:description].to_s,
        user_name: parsed_payload[:user][:name],
        approver: submission[:approver],
        response_url: response_url
      }
      command = "Commands::RequestApproval"
      response_body = {}
    elsif parsed_payload[:type] == "interactive_message"
      if parsed_payload[:callback_id].include? Constants::HOOP_REQUEST
        command_params = {
          type: parsed_payload[:type],
          approver: parsed_payload[:user][:name],
          response_url: response_url,
          action: action,
          callback_id: parsed_payload[:callback_id],
          user_name: parsed_payload[:user][:name],
        }
        command = "Commands::ProcessHoopResponse"
      end
      response_body = "Thank you!"
    end

    if command_params.present?
      CommandWorker.perform_async(command, command_params.to_h)
    end

    render json: response_body, status: :ok
  end

  private

  def action
    parsed_payload[:actions].first[:value]
  end

  def response_url
    parsed_payload[:response_url]
  end

  def submission
    parsed_payload[:submission]
  end

  def parsed_payload
    JSON.parse(params[:payload]).with_indifferent_access
  end
end
