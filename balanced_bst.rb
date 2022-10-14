class Node
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
  end
end

class Tree
  attr_accessor :root
  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(array)
    sorted_array = array.sort.uniq
    
    return if sorted_array.empty?

    n = sorted_array.size
    mid = n / 2
    root = Node.new(sorted_array[mid])
    root.left = build_tree(sorted_array[0...mid])
    root.right = build_tree(sorted_array[(mid + 1)..n])

    root
  end

  def insert(value, node = root)
    new_node = Node.new(value)
    return nil if value == node.data
    
    if value < node.data
      node.left == nil ? node.left = new_node : insert(value, node.left)
    else value > node.data
      node.right == nil ? node.right = new_node : insert(value, node.right)
    end
  end
end