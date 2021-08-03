class DataHash
  attr_accessor :data_hash
  
  def initialize
    @data_hash = Hash.new(false)

  end

  def get(*keys)
    output = []
    keys.each do |key|
      if @data_hash.key?(key) 
        output << @data_hash.fetch(key)
      else output << nil
      end
    end
    return output
  end

  def set(key, data_entry)
    @data_hash[key] = data_entry
  end

  def has_key?(key)
    return @data_hash.has_key?(key)
  end

  def get_all
    return @data_hash
  end

  def set_all(data)
    @data_hash = data
  end

  def empty?
    return @data_hash.empty?
  end
end