class QueueElement
  def initialize(obj, read_loop, str_priority = 'low')
    @obj = obj
    @str_priority = str_priority
    @num_priority = 1
    @read_loop = read_loop
  end

  def num_priority
    return @num_priority
  end

  def str_priority
    return @str_priority
  end

  def execute
    @obj.execute
    #only toggle the looper if it exists
    if @read_loop then @read_loop.true end
  end

  def set_n_priority(n)
    @num_priority = n
  end
end
