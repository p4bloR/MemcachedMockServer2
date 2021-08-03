class Looper
  def initialize
    @condition = true
  end

  def toggle
    @condition = !@condition
  end

  def cond
    return @condition
  end

  def false
    @condition = false
  end

  def true
    @condition = true
  end
end