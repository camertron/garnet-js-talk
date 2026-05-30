require "prism"

class Interpreter < Prism::Visitor
  def visit_statements_node(node)
    node.body.map { |body_node| visit(body_node) }.last
  end

  def visit_call_node(node)
    receiver = visit(node.receiver)
    arguments = visit(node.arguments)
    receiver.send(node.name, *arguments)
  end

  def visit_integer_node(node)
    node.value
  end

  def visit_arguments_node(node)
    node.arguments.map do |arg_node|
      visit(arg_node)
    end
  end
end

ast = Prism.parse("1 + 2").value
puts Interpreter.new.visit(ast)
