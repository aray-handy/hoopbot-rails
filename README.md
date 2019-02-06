# Hoopbot

# Setup Instructions
* `git co https://github.com/aray-handy/hoopbot-rails`
* `cd hoopbot-rails`
* `bundle install`
* `touch config/application.yml`

For Google API integration:
* Create a new Google API project at https://console.cloud.google.com/apis/dashboard
* Click on "Enable APIS and Services" and add Google Sheets and Google Calendar
* Create a new service account for that API integration
* Look for the private key and client email address that you then add to your `.env` file

* Add a new app to your slack workspace https://api.slack.com/apps
* Add a new slash command and use the ngrok url as the request url
* Install the app to your workspace
* Now you can access the / commands
* Copy the slack API token

* Add the following keys to your `.env` file:
    * GOOGLE_PRIVATE_KEY
    * GOOGLE_CLIENT_EMAIL
    * SLACK_SLASH_COMMAND_TOKEN
    * HOOP_SHEET_ID - create a new google sheet and copy the id from the address bar

# To run the app
* Run `ngrok http 3000`
* Run `rails s`
* Run `redis`
* Run `sidekiq`
