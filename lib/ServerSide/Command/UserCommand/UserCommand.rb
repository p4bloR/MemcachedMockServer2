require_relative '../Command'

class UserCommand < Command
  @command_name = nil
  @class_name = nil
  @parameters = nil #minimum parameters needed

  def self.get_data
    command_data = {
      :command_name => @command_name,
      :class_name => @class_name,
      :parameters => @parameters
    }

    return command_data
  end

  def format_check
  end

end

