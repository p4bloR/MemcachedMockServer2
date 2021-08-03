require_relative '../UserCommand'
require_relative '../../../SystemStrings'

class ServerCommand < UserCommand

  def initialize (connection, data_hash, input = '')
  end

  def self.format_check(input, n)
    if !parameter_count_check(input, n) then return SystemStrings.error end
    return SystemStrings.success
  end

  def self.parameter_count_check (input, n)
    return input.size >= n
  end


end