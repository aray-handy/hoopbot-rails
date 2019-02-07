module Commands
  class ProcessHoopResponse
    attr_accessor :type, :approver, :response_url, :action, :callback_id

    def initialize(params)
      @type = params[:type]
      @approver = params[:user][:name]
      @response_url = params[:response_url]
      @action = params[:action]
      @callback_id = params[:callback_id]
    end

    def run
      hoop_id = callback_id.split(":").last
      hoop = Hoop.find(hoop_id)

      if action == "approve"
        hoop.approve!
      else
        hoop.decline!
      end
    end
  end
end
