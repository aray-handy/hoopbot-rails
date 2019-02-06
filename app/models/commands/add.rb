module Commands
  class Add
    attr_accessor :text, :response_url, :user_name

    def initialize(params)
      @user_name = params["user_name"]
      @text = params["text"].gsub("add", "")
      @response_url = params["response_url"]
    end

    def run
      start_date = text.split(":").first.strip
      end_date = text.split(":").last.try!(:strip)

      params = {
        slack_user_name: user_name,
        hoop_type: Types::OOO,
        start_date: Date.strptime(start_date, "%Y-%m-%d"),
        end_date: Date.strptime(end_date, "%Y-%m-%d"),
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
