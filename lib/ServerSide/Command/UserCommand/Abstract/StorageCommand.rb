require_relative '../UserCommand'
require_relative '../../../SystemStrings'


class StorageCommand < UserCommand

  def initialize (connection, data_hash, input = '')
  end

  def execute
  end

  def self.format_check(input, n)
    #run all checks
    if !parameter_count_check(input, n) then return SystemStrings.error end

    if !positive_int_check(input, n) then return SystemStrings.bad_format end

    if !lines_check(input) then return SystemStrings.more_input end

    if !byte_count_check(input) then return SystemStrings.bad_data end
    return SystemStrings.success
  end

  def self.positive_int_check(input, n)
    m = 2
    input = input.lines[0].split(' ')[m...(m+n)]
    return input.each.all? do |x| x.match? /\A\d+\z/ end
  end

  def self.parameter_count_check (input, n)
    input = input.lines[0].split(' ')
    input = input.drop(1)
    return input.size == n
  end

  def self.byte_count_check(input)

    if input.nil? then return false end
    value = input.lines[1].chomp
    bytes = input.lines[0].split(' ')[4]

    return value.length == Integer(bytes)
  end

  def self.lines_check(input)
    return input.lines.size > 1
  end
end