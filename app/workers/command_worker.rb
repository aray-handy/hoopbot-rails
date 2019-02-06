class CommandWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false

  def perform(params)
    Commands::Processor.init(params).run
  rescue => e
    puts e.message
    puts e.backtrace
  end
end
