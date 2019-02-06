module Commands
  class Add
    attr_accessor :type, :start_date, :end_date, :response_url, :user_name

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
    end

    def run
      params = {
        slack_user_name: user_name,
        hoop_type: type,
        start_date: start_date,
        end_date: end_date
      }

      SheetWriter.write(*params.values)

      HoopEvent.create!(params)

      message = {
        text: "Thanks @#{user_name}! Added to HOOP! You're all set!",
        response_type: "ephemeral"
      }

      HTTParty.post(response_url, { body: message.to_json, headers: {
          "Content-Type" => "application/json"
        }
      })
    end
  end
end
