class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :validate_request, only: :create

  def validate_request
    slack_signing_secret = ENV["SIGNING_SECRET"]
    request_body = request.body.read
    timestamp = request.headers['X-Slack-Request-Timestamp']
    sig_basestring = 'v0:' + timestamp + ':' + request_body
    my_signature = 'v0=' + OpenSSL::HMAC.hexdigest("SHA256", slack_signing_secret, sig_basestring)

    slack_signature = request.headers['X-Slack-Signature']

    unless my_signature.to_s == slack_signature.to_s
      render json: {}, status: :forbidden
    end
  end
end
