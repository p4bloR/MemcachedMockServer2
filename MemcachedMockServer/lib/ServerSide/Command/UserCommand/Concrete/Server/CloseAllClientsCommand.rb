#require_relative '../Command'
#require_relative '../SystemStrings'
#require_relative '../ServerCommand'
require_relative 'CloseClientCommand'
require_relative '../../../../../ClientSide/Client'


class CloseAllClients < CloseClient
  @command_name = 'close_all_clients'
  @class_name = 'CloseAllClients'
  @parameters = 0 #minimum parameters needed

  def initialize(communicator = false, threader, server_loop)
    @communicator = communicator
    @threader = threader
    @server_loop = server_loop
  end

  def execute
    close_all_clients_command
  end

  def close_all_clients_command
    #execute close  client forr all clients
    @threader.threads.each_value do |conn|
      communicator = conn[:communicator]
      close_client_command(communicator)
    end


  end

end