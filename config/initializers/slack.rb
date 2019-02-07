Slack.configure do |config|
  config.token = ENV.fetch('SLACK_BOT_TOKEN')
end
