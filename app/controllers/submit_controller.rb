class SubmitController < ApplicationController
  def create
    if parsed_payload[:type] == "dialog_submission"
      command_params = {
        type: submission[:type],
        start_date: submission[:start_date],
        end_date: submission[:end_date],
        user_name: parsed_payload[:user][:name],
        response_url: response_url
      }

      CommandWorker.perform_async(command_params.to_h)
    end

    render json: {}, status: :ok
  end

  private

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
