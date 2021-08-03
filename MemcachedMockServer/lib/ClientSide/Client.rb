require 'socket'

class Client
  def initialize(socket_address, socket_port)
    @i = 0
    begin
      @socket = TCPSocket.open(socket_address, socket_port)
      @condition = false
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET# => e 
      #if the connection is refused the server probably isn't running
      #puts e.message
      @i += 1
      if @i < 50
        sleep(0.1)
      retry 
      end
      message = "#{self}: Connection refused, is the server running?"
      puts message
      end
  end

  def run 
    @running = true
    if @socket.nil? then return false end
    puts "connected to server"
    @check_loop = Thread.new{loop do if @condition then close end end}
    @read_loop = Thread.new {loop do read end}
    @write_loop = Thread.new{loop do write end}
    @read_loop.join
    @write_loop.join
  end

  def read
    unless @condition 
      begin
        if @socket.nil? then close end
        response = @socket.gets
        response ||= ''
        response.chomp!
        close_check(response)
        puts response
        return response
      rescue Errno::EPIPE, Errno::ECONNRESET
        close
      end

    end
  end

  def write
    unless @condition 
      begin
        #if @socket.nil? then close end        
        message = $stdin.gets
        message ||= '' #this idiom avoids nil errors
        message.chomp!
        @socket.puts message    
        return message
      rescue Errno::EPIPE, Errno::ECONNRESET
        close
      end
    end
  end

  def direct_write(message)
    unless @socket.nil?
      begin
        @socket.puts message
        return message
      rescue Errno::EPIPE, Errno::ECONNRESET
        close
      end
    end
  end

  def direct_read(response)
    unless @socket.nil?
      @socket.puts response
      return response
    end
  end  

  def close
    if @running
      Thread.kill(@read_loop)
      Thread.kill(@write_loop)
    end
    unless @socket.nil?
      @socket.close 
    end

    if !@check_loop.nil? then Thread.kill(@check_loop) end
  end

  def close_check(input)
    if (input) == "close client"

      @condition = true
    end
  end
end

#client1 = Client.new('localhost', 8080)

#client1.run
