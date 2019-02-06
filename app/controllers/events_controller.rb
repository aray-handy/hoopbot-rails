class EventsController < ApplicationController
  def create
    render json: { challenge: params[:challenge] }, status: 200
  end
end
