class MaxIntSet
  def initialize(max)
    @store = Array.new(max) { false }
  end

  def insert(num)
    raise Exception.new("Out of bounds") unless is_valid?(num)
    @store[num] = true
  end

  def remove(num)
    @store[num] = false
  end

  def include?(num)
    @store[num]
  end

  private

  def is_valid?(num)
    num.between?(0, @store.length-1)
  end

  def validate!(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    self[num] << num unless self[num].include?(num)
  end

  def remove(num)
    raise "#{num} not included in set" unless self.include?(num)
    self[num].delete(num)
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet < IntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    super
    @count = 0
  end

  def insert(num)
    resize! if count == num_buckets
    unless self[num].include?(num)
      self[num] << num
      @count += 1
    end
  end

  def remove(num)
    if self.include?(num) 
      self[num].delete(num)
      @count -= 1
    end
  end

  private

  def resize!
    store = @store.dup
    @count = 0
    @store = Array.new(num_buckets * 2) { Array.new }
    store.flatten.each { |num| self.insert(num) }
  end
end
