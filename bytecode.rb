class PutObjectInt2Fix1
  def call(stack)
    stack.push(1)
  end
end

class PutObject
  def initialize(object)
    @object = object
  end

  def call(stack)
    stack << @object
  end
end

class OptPlus
  def call(stack)
    arg = stack.pop
    receiver = stack.pop
    stack.push(receiver + arg)
  end
end

class Leave
  def call(_stack)
  end
end

instructions = [
  PutObjectInt2Fix1.new,
  PutObject.new(2),
  OptPlus.new,
  Leave.new
]

stack = []

instructions.each do |instruction|
  instruction.call(stack)
end

puts stack.pop.inspect
