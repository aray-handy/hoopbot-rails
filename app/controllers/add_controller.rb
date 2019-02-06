class AddController < ApplicationController
  def create
    message = {
      "trigger_id": params[:trigger_id],
      "dialog": {
        "callback_id": "ryde-46e2b0",
        "title": "Add an OOO",
        "submit_label": "Add",
        "notify_on_cancel": true,
        "elements": [
            {
                "type": "select",
                "label": "Type",
                "name": "type",
                "options": [
                    {
                      "label": "Out of Office",
                      "value": "OOO"
                    },
                    {
                      "label": "Out of Office - Half Day",
                      "value": "HALF_OOO"
                    },
                    {
                      "label": "Work from Home",
                      "value": "WFH"
                    },
                    {
                      "label": "Sick Day",
                      "value": "SICK"
                    },
                    {
                      "label": "Work from Home - Half Day",
                      "value": "HALF_WFH"
                    }
                ],
            },
            {
              "type": "text",
              "label": "What's this OOO for?",
              "name": "description",
              "placeholder": "Headed to Iceland!",
              "optional": true,
            },
            {
                "type": "text",
                "label": "First day you are OOO",
                "name": "start_date",
                "placeholder": "yyyy-mm-dd"
            },
            {
                "type": "text",
                "label": "Last day you are OOO",
                "name": "end_date",
                "placeholder": "yyyy-mm-dd",
                "optional": true,
            }
        ]
      }
    }

    puts HTTParty.post("https://slack.com/api/dialog.open", {
      body: message.to_json,
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV["SLACK_SLASH_COMMAND_TOKEN"]}"
      }
    })
  end
end
