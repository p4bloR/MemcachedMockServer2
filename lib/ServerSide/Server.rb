require 'socket'
require_relative 'Communicator'
require_relative 'CommandValidator'
require_relative 'CommandAssembler'
require_relative 'CommandHash'
require_relative 'SystemStrings'
require_relative 'DataHash'
require_relative 'PriorityQueue'
require_relative 'ConnectionThreader'
require_relative 'Looper'
require_relative 'CommandSender'
require_relative 'ExpireChecker'
require_relative 'DataEntry'
require_relative './Command/UserCommand/Concrete/Server/CloseServerCommand'

class Server

  attr_accessor :busy
  def initialize(socket_address, socket_port) 
    @busy = false
    @socket_address = socket_address
    @socket_port = socket_port
    connect
    @commands = CommandHash.new
    @validator = CommandValidator.new(@commands.get)
    @data_hash = DataHash.new
    @queue = PriorityQueue.new
    @threader = ConnectionThreader.new
    @server_loop = Looper.new
    @assembler = CommandAssembler.new(@server_loop, @data_hash, @commands.get, @threader)
    @sender = CommandSender.new(@queue)
    @expirer = ExpireChecker.new(@sender, @queue, @data_hash, 1)
  end

  def connect
    i = 0
    begin
      @server_socket = TCPServer.open(@socket_address, @socket_port)
    rescue Errno::EADDRINUSE
      # this is a pseudo timeout
      if i <= 25
        sleep(0.1)
        i += 1
        retry
      end
      @busy = true
      puts "Port is busy, maybe try another"
      exit
    end
  end

  def accept_connection #original
    begin 
      @client_connection = @server_socket.accept_nonblock
      return @client_connection
    rescue IO::WaitReadable, Errno::EINTR#, Timeout::Error
      begin
        IO.select([@server_socket])
        retry
      rescue
        retry
      end
    end 
  end

  def establish_communication(connection)
    communicator = Communicator.new(connection)
    #the read looper will make sure the user can't input a new 
    #command while a previous command is still being executed
    read = Looper.new

    #connected allows to close the connection for users
    #that interrupt their connection without using any commands
    connected = Looper.new

    #saving data to threads
    con = connection.to_s.to_sym
    data = {
      connection: connection,
      communicator: communicator,
      read_looper: read,
      connected_looper: connected
    }

    @threader.threads[con] = data

    #if the server looper is false close the server
    if !@server_loop.cond
      self.close 
   end 

   #a loop to constanly get input from user
    while connected.cond && @server_loop.cond do 
      if connected.cond && @server_loop.cond
        stage_a(communicator, read, connected)

      elsif !connected.cond
        break
      end
    end
    # this gets executed if the user gets suddenly disconnected
    connection.close
    return false
  end

  def close
    @queue.kill
    @expirer.kill
    close_comm = CloseServer.new(@threader, @server_loop)    
    close_comm.execute
    @server_loop.false
    puts ""
    @server_socket.close
    return "server closed"

  end

  def run_components
    @queue.run(@server_loop)
    @expirer.run(@server_loop)    
  end

  def run
    run_components
    puts "Server is running"
    while @server_loop.cond do
      Thread.start(accept_connection) do |connection|
          establish_communication(connection)
      end      
    end
  end

  #stage A gets user input
  def stage_a(communicator, read, connected)
    unless read then return false end

    if input = communicator.listen
      stage_b(input, communicator, read, connected)

    else 
      read.false
      connected.false
      return false
    end
  end 

  #stage B runs the validator
  def stage_b(input, communicator, read, connected)
    validation = @validator.validate(input)

    if SystemStrings.error_strings.include? validation[:message]
      communicator.write(validation[:message])

    elsif validation[:message] == SystemStrings.success
      stage_e(input, communicator, validation, read)

    elsif validation[:message] == SystemStrings.more_input
      stage_c(input, communicator, validation, read, connected)

    else communicator.write(SystemStrings.error)

    end
  end
  #stage C gets morye input when necessary 
  # like in storage commands
  def stage_c(input, communicator, validation, read, connected)
    input << "\r\n"

    if input << communicator.listen
      input << "\r\n adding empty check line"
      stage_d(input, communicator, validation, read)
    else
      read.false
      connected.false
    end
  end

  #stage D validates the new input
  def stage_d(input, communicator, validation, read)
    validation = @validator.validate(input, validation[:type], validation[:command_name])
    if SystemStrings.error_strings.include? validation[:message]
      communicator.write(validation[:message])
    else 
      stage_e(input, communicator, validation, read)
    end
  end

  #stage E creates the command object through the assembler
  def stage_e(input, communicator, validation, read)
    if input.lines.size > 1
      last = input.lines.size
      input = input.lines[...(last - 1)]
      input = input.join("")
    end

    comm = @assembler.assemble(input, communicator, validation)
    stage_f(comm, read)
  end

  #stage F sends the command to the queue
  # the queue will execute it ASAP
  def stage_f(comm, read)
    read.false
    @sender.send(comm, read)
  end
end
