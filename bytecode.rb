require "prism"

class Compiler < Prism::Visitor
  def self.compile(ast)
    compiler = new
    compiler.visit(ast)

    instructions = compiler.instructions
    instructions << Leave.new
    instructions
  end

  attr_reader :instructions

  def initialize
    @instructions = []
  end

  def visit_call_node(node)
    visit(node.receiver)
    visit(node.arguments)

    call_data = CallData.new(node.name, node.arguments.arguments.size)

    if node.name == :+
      instructions << OptPlus.new(call_data)
    else
      # TODO: generate generic send instructions
    end
  end

  def visit_integer_node(node)
    if node.value == 1
      instructions << PutObjectInt2Fix1.new
    else
      instructions << PutObject.new(node.value)
    end
  end
end

class CallData
  attr_reader :mid, :argc

  def initialize(mid, argc)
    @mid = mid
    @argc = argc
  end
end

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
  attr_reader :call_data

  def initialize(call_data)
    @call_data = call_data
  end

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

ast = Prism.parse("1 + 2").value
instructions = Compiler.compile(ast)

stack = []

instructions.each do |instruction|
  instruction.call(stack)
end

puts stack.pop.inspect
