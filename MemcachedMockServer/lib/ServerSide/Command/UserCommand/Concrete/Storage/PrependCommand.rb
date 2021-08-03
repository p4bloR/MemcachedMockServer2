#require_relative '../StorageCommand'
#require_relative '../DataEntry'
#require_relative '../SystemStrings'
require_relative 'SetCommand'

class  PrependCommand < SetCommand
  @command_name = 'prepend'
  @class_name = 'PrependCommand'
  @parameters = 4 #minimum parameters needed

  def initialize(communicator, target_hash, value, key, flag, ttl, bytes)
    @communicator = communicator
    @data_hash = target_hash.data_hash
    @key = key
    @flag = flag
    @ttl = ttl
    @bytes = Integer(bytes)
    @value = value
  end

  def execute
    prepend_command
  end

  def prepend_command
    if @data_hash.key?(@key)
      @value = @value.chomp + @data_hash[@key].value  
      @bytes += @data_hash[@key].bytes
      set_command
    else
      @communicator.write(SystemStrings.not_stored)
    end
  end

end