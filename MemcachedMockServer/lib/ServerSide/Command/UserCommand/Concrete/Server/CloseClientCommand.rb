require_relative '../../../Command'
require_relative '../../../../SystemStrings'
require_relative '../../Abstract/ServerCommand'

class CloseClient < ServerCommand
  @command_name = 'close_client'
  @class_name = 'CloseClient'
  @parameters = 0 #minimum parameters needed

  def initialize(communicator, threader, server_loop)
    #@connection = communicator.connection
    @communicator = communicator
    @threader = threader
  end

  def execute
    close_client_command(@communicator)
  end

  def close_client_command(communicator, message = 'close client')
    conn = communicator.connection
    conn = conn.to_s.to_sym
    connection = @threader.threads.dig(conn, :connection)
    
    read = @threader.threads.dig(conn, :read_looper)
    connected = @threader.threads.dig(conn, :connected_looper)
    #making the loopers = false
    read.false
    connected.false
    communicator.write(message)
  end
end