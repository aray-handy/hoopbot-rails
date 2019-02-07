class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :validate_request, only: :create

  def validate_request
    unless request.headers["X-Slack-Signature"] == ENV["SIGNING_SECRET"]
      render status: :forbidden
    end
  end
end
