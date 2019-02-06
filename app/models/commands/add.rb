module Commands
  class Add
    attr_accessor :text, :response_url, :user_id

    def initialize(params)
      @user_id = params["user_id"]
      @text = params["text"].gsub("add", "")
      @response_url = params["response_url"]
    end

    def run
      start_date = text.split("to").first.strip
      end_date = text.split("to").last.try!(:strip)

      SheetWriter.write(user_id, Types::OOO, start_date, end_date)

      message = {
        text: "Added to HOOP! You're all set!",
        response_type: "ephemeral"
      }

      HTTParty.post(response_url, { body: message.to_json, headers: {
          "Content-Type" => "application/json"
        }
      })
    end
  end
end
