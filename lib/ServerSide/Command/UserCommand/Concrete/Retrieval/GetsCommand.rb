require_relative '../../Abstract/RetrievalCommand'
require_relative '../../../../DataEntry'
require_relative '../../../../SystemStrings'

class GetsCommand < RetrievalCommand
  @command_name = 'gets'
  @class_name = 'GetsCommand'
  @parameters = 1 #minimum parameters needed

  def initialize(communicator, target_hash, *keys)
    @communicator = communicator
    @data_hash = target_hash.data_hash
    @keys = keys
  end

  def execute
    gets_command
  end


  def gets_command(n = 0)
    result = []
    @keys.each do |key|
      if @data_hash.key?(key) 
        result << @data_hash.fetch(key)
      #else result << ''
      end
    end    
    result.each do |data_entry|
    print_value(data_entry, n)
    end
    @communicator.write(SystemStrings.end)
  end

  def print_value(data_entry, n)
    if !data_entry.nil?
      val = SystemStrings.value
      data = data_entry.get_data
      data ||= ['']
      v = data.last.to_s
      data.pop

      if n <= data.size 
        m = data.size - n  
      end

      data[...m].each do |x|
        val += " #{x}"
      end

      val += "\r\n"+ "#{v}"

      @communicator.write(val)
    end
  end
end