require_relative 'SystemStrings'
require_relative './Command/UserCommand/Abstract/StorageCommand'
require_relative './Command/UserCommand/Abstract/RetrievalCommand'
require_relative './Command/UserCommand/Abstract/ServerCommand'

class CommandValidator
  
  def initialize(commands)
    @command_hash = commands
    @command_hash ||= ''
  end

  def validate(input, type = false, command_name = false)
    out = Hash.new(nil)

    #check if user input is nil
    if input.nil?
     out[:message] = SystemStrings.error 
     return out 
   end

    #check if user input is empty
    if !empty_check(input)      
     out[:message] = SystemStrings.error 
     return out 
   end

    #check if the command exists
    if i = identify_command(input, type, command_name)
      type, class_name, parameters, command_name = i[0],i[1],i[2],i[3]
      validation = (type + '_validate').to_sym
      #dynamically select corresponding validation method
      result = self.send(validation, input, parameters)
    else
      out[:message] = SystemStrings.error
      return out
    end


    out = {
    :message => result,
    :type => type,
    :class_name => class_name,
    :command_name => command_name}
    return out 

  end

  def identify_command(input, type = false, command_name = false)

    input = input.split(' ')

    if type && command_name
      value = @command_hash.dig(type.to_sym, command_name.to_sym)
      output = get_command_data(type, value, input[0])
      return output

    else
      @command_hash.each do |key1, value1|
        value1.each_value do |value2|
          if output = get_command_data(key1, value2, input[0])
          return output
          end
        end
      end      
    end
    return false
  end


  def get_command_data(key1, value, input)
    if value[:command_name] == input
      type = key1.to_s
      class_name = value[:class_name]   
      params = value[:parameters]  
      command_name = value[:command_name] 
      return type, class_name, params, command_name
    else
      return false
    end
  end

  def empty_check(input)
    if input.empty? || input.size <= 0
      return false 
    end
    return true
  end

  def storage_validate(input, params)
    validation = StorageCommand.format_check(input, params)
    return validation
  end

  def retrieval_validate(input, params)
    validation = RetrievalCommand.format_check(input, params)
    return validation
  end

  def server_validate(input, params)
    validation = ServerCommand.format_check(input, params)
  end
end