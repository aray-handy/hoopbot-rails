module Commands
  module Processor
    extend self

    def init(params)
      task = task(params).titleize
      "Commands::#{task}".constantize.new(params)
    end

    # Given `task:sub message`, return task
    def task(params)
      params["text"].scan(/\w+/).first
    end

    # Given `task:sub message`, return subtask
    def subtask(params)
      params["text"].scan(/\w+/)[1]
    end

    # Given `task:sub message`, return message
    def message(params)
      params["text"][/\w+:\w+\s(.*)/, 1]
    end
  end
end
