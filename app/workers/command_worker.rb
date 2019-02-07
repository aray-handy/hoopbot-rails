class CommandWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(command, params)
    command.constantize.new(params).run
  rescue => e
    puts e.message
    puts e.backtrace
  end
end
