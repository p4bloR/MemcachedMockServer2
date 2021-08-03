#require_relative '../Command'
#require_relative '../SystemStrings'
#require_relative '../ServerCommand'
require_relative 'CloseAllClientsCommand'
#require_relative '../Client'


class CloseServer < CloseAllClients
  @command_name = 'close_server'
  @class_name = 'CloseServer'
  @parameters = 0 #minimum parameters needed

  def initialize(communicator = false, threader, server_loop)
    @communicator = communicator
    @threader = threader
    @server_loop = server_loop
  end

  def execute
    close_server_command
  end

  def close_server_command
    @server_loop.false
    close_all_clients_command
    #the run method is always listening for 
    #connections to accept, just like a gets method
    #it will just keep waiting. Creating a new user stops that
    #and setting the looper to false will prevent the loop
    #from running again and thus listening again
    client = Client.new('localhost', 8080)
    client.close
  end

end