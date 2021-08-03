
Dir["#{File.dirname(__FILE__)}/Command/UserCommand/**/*.rb"].each {|f| require_relative(f)}

class CommandHash

  def initialize
    #set the cas id seed to 0
    DataEntry.set_seed 
    @command_hash = Hash.new
    set_command_hash
  end

  def get
    return @command_hash
  end

  #save command data to command_hash
  def set_command_hash
    descendants_array = get_descendants_array
    retrieval_hash = Hash.new
    storage_hash = Hash.new
    server_hash = Hash.new

    retrieval_hash = fill_type_hash(retrieval_hash, descendants_array[0])
    storage_hash = fill_type_hash(storage_hash, descendants_array[1])
    server_hash = fill_type_hash(server_hash, descendants_array[2])

    @command_hash = {
    :retrieval => retrieval_hash,
    :storage => storage_hash, 
    :server => server_hash
    }
  end

  def get_descendants_array()
    descendants_array = Array.new

    descendants_array << retrieval = descendants(RetrievalCommand)
    descendants_array << storage = descendants(StorageCommand)
    descendants_array << server = descendants(ServerCommand)

    return descendants_array
  end

  def fill_type_hash(comm_hash, comm_array)
      comm_array.each do |klass|
        
        klass_name = Object.const_get(klass.to_s)
        comm_data = klass_name.get_data
        key = (comm_data[:command_name]).to_sym
        value = comm_data
        comm_hash[key] = value
      end
      return comm_hash
  end

  def descendants(parent)
    return ObjectSpace.each_object(Class).select{|klass| klass < parent}
  end
end
