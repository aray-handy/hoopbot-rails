module Commands
  class OpenHoopDialog
    attr_accessor :trigger_id

    def initialize(params)
      @trigger_id = params[:trigger_id]
    end

    def run
      message = {
        "trigger_id": trigger_id,
        "dialog": {
          "callback_id": "hoop_form",
          "title": "Add an OOO",
          "submit_label": "Add",
          "notify_on_cancel": false,
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
            },
            {
                "type": "select",
                "label": "Approver",
                "name": "approver",
                "data_source": "users"
            }
          ]
        }
      }

      SlackHttpService.post("https://slack.com/api/dialog.open", message, as: :app)
    end
  end
end
