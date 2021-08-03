class ConnectionThreader
  attr_accessor :threads
  
  def initialize
    @threads = Hash.new
  end
end