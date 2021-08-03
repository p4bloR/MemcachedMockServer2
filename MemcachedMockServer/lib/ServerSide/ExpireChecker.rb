require_relative 'Command/InternalCommand/Concrete/DeleteExpiredCommand'

class ExpireChecker
  def initialize(sender, queue, target_hash, frequency)
    @sender = sender
    @frequency = 1/frequency # in times per second
    @queue = queue
    @target_hash = target_hash
  end

  def run(server_loop)
    @exp_thread = Thread.new do
      condition = server_loop.cond
      #only run if server_loop.cond is true
      while condition do
        condition = server_loop.cond
        sleep(@frequency)
        comm = assemble
        #this command has higher priority than user commands
        #and false since it has no communicator
        @sender.send(comm, false,'high')
      end
      #kill thread if loop is broken
      kill
    end
  end

  def assemble
    comm = DeleteExpiredCommand.new(@target_hash)
    return comm
  end

  def kill
    unless @exp_thread.nil? then Thread.kill(@exp_thread) end
  end

end