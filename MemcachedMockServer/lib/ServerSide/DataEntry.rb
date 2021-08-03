class DataEntry

  @@cas_seed = 0

  attr_accessor :ttl
  attr_reader :cas
  attr_reader :value
  attr_reader :bytes

  def initialize(key, flag, ttl, bytes, value = '')
  #each MemObject has a key, flag, expiretime, bytes and value
  @key = key
  @value = value
  @flag = flag
  @ttl = Integer(ttl)
  @bytes = Integer(bytes)
  @cas = DataEntry.update_cas
  end
  #each Memcached Object has an unique cas seed

  def self.set_seed
    @@cas_seed = 0
  end

  def self.update_cas
    @@cas_seed += 1
    return @@cas_seed
  end

  def update_ttl
      @ttl -= 1
    return @ttl
  end

  def get_data
    return @key, @flag, @bytes, @cas, @value
  end
end