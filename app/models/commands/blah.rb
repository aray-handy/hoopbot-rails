module Commands
  class Blah
    def initialize(params)
      @trigger_id = params["trigger_id"]
      @user_name = params["user_name"]
      @text = params["text"].gsub("add", "")
      @response_url = params["response_url"]
    end

    def run
      message = {
        "callback_id": "ryde-46e2b0",
        "title": "Request a Ride",
        "submit_label": "Request",
        "notify_on_cancel": true,
        "state": "Limo",
        "elements": [
            {
                "type": "text",
                "label": "Pickup Location",
                "name": "loc_origin"
            },
            {
                "type": "text",
                "label": "Dropoff Location",
                "name": "loc_destination"
            }
        ]
      }


      HTTParty.post("response_url", { body: message.to_json, headers: {
          "Content-Type" => "application/json"
        }
      })
    end
  end
end
