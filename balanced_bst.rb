class Node
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
  end
end

class Tree

  def initialize(array)
    @root = build_tree(array)
  end
end