class HoopDialogController < ApplicationController
  def create
    Commands::OpenHoopDialog.new(dialog_params.to_h).run
  end

  private

  def dialog_params
    params.permit(:trigger_id)
  end
end
