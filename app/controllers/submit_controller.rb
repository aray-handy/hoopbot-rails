class SubmitController < ApplicationController
  def create
    if parsed_payload[:type] == "dialog_submission"
      command_params = {
        type: submission[:type],
        start_date: submission[:start_date],
        end_date: submission[:end_date],
        description: submission[:description].to_s,
        user_name: parsed_payload[:user][:name],
        response_url: response_url
      }

      approvee_name = parsed_payload[:user][:name]

      open_message = {
        user: parsed_payload[:user][:id], 
      }

      response = HTTParty.post("https://slack.com/api/im.open", {
        body: open_message.to_json,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{ENV["SLACK_BOT_TOKEN"]}"
        }
      })

      channel_id = response["channel"]["id"]

      post_message = {
        channel: channel_id,
        text: "Approve vacay for #{parsed_payload[:user][:name]} from #{submission[:start_date]} to #{submission[:end_date]}",
        icon_emoji: ":desert_island:",
        attachments: [
          {
            "fallback": "Woops something went wrong",
            "callback_id": "wopr_approver",
            "color": "#3AA3E3",
            "attachment_type": "default",
            "actions": [
              {
                "name": "yes",
                "text": "Yes",
                "type": "button",
                "value": approvee_name,
              },
              {
                "name": "no",
                "text": "No",
                "type": "button",
                "value": approvee_name,
              }
            ]
          }
        ]
      }

      HTTParty.post("https://slack.com/api/chat.postMessage", {
        body: post_message.to_json,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{ENV["SLACK_BOT_TOKEN"]}"
        }
      })

      CommandWorker.perform_async(command_params.to_h)
      render json: {}, status: :ok
    elsif parsed_payload[:type] == "interactive_message" 
      user_name = parsed_payload[:user][:name]
      hoop_event = HoopEvent.where(slack_user_name: user_name).last
      approval_status = parse_approval_status(params)
      hoop_event.update_column(:status, approval_status)

      interactive_response =
        if approval_status == "approved"
          "Yay"
        else
          "Boo"
        end

      render json: { text: interactive_response }, status: :ok
    end
  end

  private

  def parse_approval_status(params)
    action = parsed_payload[:actions].first

    if action[:name] == "yes"
      "approved"
    else
      "rejected"
    end
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
