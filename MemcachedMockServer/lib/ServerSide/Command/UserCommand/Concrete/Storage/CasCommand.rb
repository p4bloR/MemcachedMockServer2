#require_relative '../StorageCommand'
#require_relative '../DataEntry'
#require_relative '../SystemStrings'
require_relative 'SetCommand'

class  CasCommand < SetCommand
  @command_name = 'cas'
  @class_name = 'CasCommand'
  @parameters = 5 #minimum parameters needed

  def initialize(communicator, target_hash, value, key, flag, ttl, bytes, cas)
    @communicator = communicator
    @data_hash = target_hash.data_hash
    @key = key
    @flag = flag
    @ttl = ttl
    @bytes = bytes
    @value = value
    @cas = cas
  end

  def execute
    cas_command
  end

  def cas_command
    if data_entry = @data_hash[@key]
      if data_entry.cas.to_s == @cas
        set_command
      else
        @communicator.write(SystemStrings.exists)
      end
    else
      @communicator.write(SystemStrings.not_found)
    end
  end
end