class PriorityQueue
  #the lesser the number the higher the priority
  # its a minimum binary heap

  def initialize
    @heap = [nil]
  end

  def run(server_loop)
    @q_thread = Thread.new do 
      condition = server_loop.cond      
      while condition do 
        condition = server_loop.cond
        execute 
      end 
      kill
    end#.join
  end

  def kill
    unless @q_thread.nil? then Thread.kill(@q_thread) end
  end

  def insert(item)
    assing_priority(item)
    @heap << item
    bubble_up(last_index)
    self
  end

  def pop
    minimum = @heap[1]
    swap(1, last_index)
    @heap.pop
    bubble_down(1)
    minimum
  end

  def execute
    if @heap.size > 1
      min = pop
      min.execute
    end
  end

  def assing_priority(element)
    if element.str_priority == 'low'
      maximum = @heap[1...].map(&:num_priority).max
      maximum ||= 0
      element.set_n_priority(maximum + 1)
    elsif element.str_priority == 'high'
      # 1 is the highest priority
      element.set_n_priority(1)
    else
      element.set_n_priority(1)
    end
    
  end
  private

  def bubble_up(index)
    parent_index = index / 2

    return if parent_index.zero?

    child = @heap[index].num_priority
    parent = @heap[parent_index].num_priority

    if parent > child
      swap(index, parent_index)
      bubble_up(parent_index)
    end
  end

  def bubble_down(index)
    left_child_index = index * 2
    right_child_index = index * 2 + 1

    return if left_child_index > last_index

    lesser_child_index = determine_lesser_child(left_child_index, right_child_index)

    if @heap[index].num_priority > @heap[lesser_child_index].num_priority
      swap(index, lesser_child_index)
      bubble_down(lesser_child_index)
    end
  end

  def determine_lesser_child(left_child_index, right_child_index)
    return left_child_index if right_child_index > last_index

    if @heap[left_child_index].num_priority < @heap[right_child_index].num_priority
      left_child_index
    else
      right_child_index
    end
  end

  def last_index
    @heap.length - 1
  end

  def swap(index_a, index_b)
    @heap[index_a], @heap[index_b] = @heap[index_b], @heap[index_a]
  end
end