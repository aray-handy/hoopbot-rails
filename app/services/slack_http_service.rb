class SlackHttpService
  def self.post(url, body, as: :app)
    if as == :app
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV["SLACK_USER_TOKEN"]}"
      }
    else
      headers = {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV["SLACK_BOT_TOKEN"]}"
      }
    end

    HTTParty.post(url, {
      body: body.to_json,
      headers: headers
    })
  end
end
