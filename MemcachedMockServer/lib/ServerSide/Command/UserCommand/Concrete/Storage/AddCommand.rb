#require_relative '../StorageCommand'
#require_relative '../DataEntry'
#require_relative '../SystemStrings'
require_relative 'SetCommand'

class  AddCommand < SetCommand
  @command_name = 'add'
  @class_name = 'AddCommand'
  @parameters = 4 #minimum parameters needed

  def execute
    add_command
  end

  def add_command
    unless @data_hash.key?(@key)
      set_command 
    else
      @communicator.write(SystemStrings.not_stored)      
    end
  end

end
