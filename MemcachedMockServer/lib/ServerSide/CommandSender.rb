class CommandSender
  def initialize(queue)
    @queue = queue
  end

  def send(comm, looper = false, priority = 'low')
    #put the command inside a queue element
    command = QueueElement.new(comm, looper, priority)
    @queue.insert(command)
  end

end