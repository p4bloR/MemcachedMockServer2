require_relative 'CommandHash'
require_relative 'PriorityQueue'
require_relative 'QueueElement'


class CommandAssembler
  def initialize(server_loop, target_hash, commands, threader)
    @server_loop = server_loop
    @target_hash = target_hash
    @command_hash = commands
    @threader = threader
  end

  def assemble(input, communicator, validation)
    #dynamically select corresponding method
    command_data = get_command_data(validation)
    type = command_data[:type]
    out = self.send(('assemble_' + type).to_sym, input, communicator, command_data)
    return out
  end
  
  def get_command_data(validation)
    type = validation[:type]
    command_name = validation[:command_name]
    data = @command_hash.dig(type.to_sym, command_name.to_sym)
    data[:type] = type

    return data
  end

  def assemble_storage(input, communicator, command_data)
    value = input.lines[1...].join(', ')
    n = command_data[:parameters] #get parameter count
    parameters = input.lines[0].chomp!.split(' ')

    parameters = parameters[1...(1 + n)]
    class_name = command_data[:class_name] #get command class
    #dynamically select command class to create
    klass = Object.const_get(class_name)
    output_command = klass.new(communicator, @target_hash, value, *parameters)
    return output_command
  end

  def assemble_retrieval(input, communicator, command_data)
    input = input.split(' ')
    parameters = input.drop(1)

    class_name = command_data[:class_name]
    #dynamically select command class to create    
    klass = Object.const_get(class_name)

    output_command = klass.new(communicator, @target_hash, *parameters)
    return output_command
  end

  def assemble_server(input, communicator, command_data)
    class_name = command_data[:class_name]
    #dynamically select command class to create
    
    klass = Object.const_get(class_name)
    output_command = klass.new(communicator, @threader, @server_loop)  
    return output_command
  end
end

