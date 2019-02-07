raise 'Missing ENV[SLACK_BOT_TOKEN]!' unless ENV["SLACK_BOT_TOKEN"]
raise 'Missing ENV[SLACK_USER_TOKEN]!' unless ENV["SLACK_USER_TOKEN"]
raise 'Missing ENV[SIGNING_SECRET]!' unless ENV["SIGNING_SECRET"]
