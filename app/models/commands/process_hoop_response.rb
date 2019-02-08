module Commands
  class ProcessHoopResponse
    attr_accessor :type, :approver, :response_url, :action, :callback_id, :user_name, :approved

    def initialize(params)
      @type = params["type"]
      @approver = params["approver"]
      @response_url = params["response_url"]
      @action = params["action"]
      @approved = @action == "approve"
      @callback_id = params["callback_id"]
      @user_name = params["user_name"]
    end

    def run
      hoop_id = callback_id.split(":").last
      hoop = HoopEvent.find(hoop_id)

      raise StandardError, "Could not find Hoop Event #{hoop_id}" if hoop.blank?

      if approved
        hoop.approve!
        SlackHttpService.post(Constants::POST_MESSAGE_URL, approval_message_to_requestor, as: :bot)
      else
        hoop.reject!
        SlackHttpService.post(Constants::POST_MESSAGE_URL, reject_message_to_requestor, as: :bot)
      end
    end

    def approval_message_to_requestor
      {
        as_user: true,
        channel: "@#{user_name}",
        text: "Hooray @#{user_name}! Your request for OOO has been approved by @#{approver}!",
        response_type: "ephemeral"
      }
    end

    def reject_message_to_requestor
      {
        as_user: true,
        channel: "@#{user_name}",
        text: "Booo @#{user_name}! Your manager's mean!!",
        response_type: "ephemeral"
      }
    end
  end
end
