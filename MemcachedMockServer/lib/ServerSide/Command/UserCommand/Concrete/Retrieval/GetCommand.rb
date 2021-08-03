#require_relative '../RetrievalCommand'
#require_relative '../DataEntry'
#require_relative '../SystemStrings'
require_relative 'GetsCommand'


class GetCommand < GetsCommand
  @command_name = 'get'
  @class_name = 'GetCommand'
  @parameters = 1 #minimum parameters needed

  def execute
    get_command
  end

  def get_command 
    #the '1' makes sure the last element
    #i.e. the cas value won't print 
    gets_command(1) 
  end

end