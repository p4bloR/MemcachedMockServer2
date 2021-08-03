#require_relative '../StorageCommand'
#require_relative '../Command'
#require_relative '../DataEntry'
#require_relative '../SystemStrings'
require_relative 'SetCommand'

class  ReplaceCommand < SetCommand
  @command_name = 'replace'
  @class_name = 'ReplaceCommand'
  @parameters = 4 #minimum parameters needed
  
  def execute
    replace_command
  end

  def replace_command
    if @data_hash.key?(@key)
      set_command 
    else
      @communicator.write(SystemStrings.not_stored)      
    end
  end
end
