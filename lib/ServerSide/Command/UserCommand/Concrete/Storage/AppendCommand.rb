#require_relative '../DataEntry'
#require_relative '../SystemStrings'
require_relative 'SetCommand'
class  AppendCommand < SetCommand
  @command_name = 'append'
  @class_name = 'AppendCommand'
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
    append_command
  end

  def append_command
    if @data_hash.key?(@key)
      @value = @data_hash[@key].value + @value.chomp 
      @bytes += @data_hash[@key].bytes
      set_command
    else
      @communicator.write(SystemStrings.not_stored)
    end
  end

end