module Commands
  class RequestApproval
    attr_accessor :type, :start_date, :end_date, :response_url, :user_name, :description, :approver, :hoop

    def initialize(params)
      @type = params["type"]
      @user_name = params["user_name"]
      @start_date = Date.strptime(params["start_date"], "%Y-%m-%d")
      @end_date = if params["end_date"]
                    Date.strptime(params["end_date"], "%Y-%m-%d")
                  else
                    @start_date
                  end
      @response_url = params["response_url"]
      @description = params["description"]
      @approver = params["approver"]
    end

    def run
      make_hoop_event!
      SlackHttpService.post(response_url, message_to_requestor, as: :app)
      SlackHttpService.post(Constants::POST_MESSAGE_URL, message_to_approver, as: :bot)
    end

    private

    def duration
      if hoop.start_date == hoop.end_date
        "on #{hoop.start_date}"
      else
        "from #{hoop.start_date} to #{hoop.end_date}"
      end
    end

    def message_to_approver
      {
        "as_user": true,
        "channel": "@#{approver}",
        "text": "Please review @#{hoop.slack_user_name} request for #{hoop.hoop_type} #{duration}",
        "attachments": [
            {
                "text": "Respond to the request",
                "fallback": "You are unable to respond to the request",
                "callback_id": "#{Constants::HOOP_REQUEST}:#{hoop.id}",
                "color": "#3AA3E3",
                "attachment_type": "default",
                "actions": [
                    {
                        "name": Constants::HOOP_REQUEST_ACTION,
                        "text": "Approve",
                        "type": "button",
                        "value": "approve"
                    },
                    {
                        "name": Constants::HOOP_REQUEST_ACTION,
                        "text": "Decline",
                        "style": "danger",
                        "type": "button",
                        "value": "decline",
                    }
                ]
            }
        ]
      }
    end

    def make_hoop_event!
      params = {
        slack_user_name: user_name,
        hoop_type: type,
        start_date: start_date,
        end_date: end_date,
        description: description,
        approver: approver
      }

      @hoop = HoopEvent.create!(params)
    end

    def message_to_requestor
      response = SlackHttpService.post(
        "https://slack.com/api/users.info?user=#{@approver}",
        {},
        as: :bot
      )

      {
        text: "Thanks @#{user_name}! We sent a request to #{response["user"]["name"]} to approve your OOO request. We'll let you know when they respond!",
        response_type: "ephemeral"
      }
    end
  end
end
