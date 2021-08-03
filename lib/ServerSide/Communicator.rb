class Communicator
  attr_reader :connection
  
  def initialize(connection)
    @connection = connection
  end

  def check_connection 
    if !@connection.nil?
      return @connection
    else
      return false
    end
  end

  def listen
    if check_connection
      begin
        if input = @connection.gets 
          input ||= ''
          input.chomp!
          return input
        end
      rescue #Errno::EPIPE, Errno::ECONNRESET
        return false
      end
    end
  end


  def write(*input)
    if check_connection
      begin
        @connection.puts input
      rescue #Errno::EPIPE, Errno::ECONNRESET, Errno::IOError
        return false
      end 
    end
  end
end