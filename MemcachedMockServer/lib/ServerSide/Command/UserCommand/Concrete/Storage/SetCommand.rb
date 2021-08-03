require_relative '../../Abstract/StorageCommand'
require_relative '../../../../DataEntry'
require_relative '../../../../SystemStrings'
require_relative '../../../../DataHash'

class SetCommand < StorageCommand
  @command_name = 'set'
  @class_name = 'SetCommand'
  @parameters = 4 #minimum parameters needed

  def initialize(communicator, target_hash, value, key, flag, ttl, bytes)
    @communicator = communicator
    @data_hash = target_hash.data_hash
    @key = key
    @flag = flag
    @ttl = ttl
    @bytes = Integer(bytes)
    @value = value.chomp
  end

  def execute
    set_command
  end

  def set_command
    data_entry = DataEntry.new(@key, @flag, @ttl, @bytes, @value)
    #@target_hash.set(@key, data_entry)
    @data_hash[@key] = data_entry
    @communicator.write(SystemStrings.stored)
  end
end

