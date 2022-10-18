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
  
  def delete(value, node = root)
    return node if node == nil
    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    elsif value == node.data
      if node.left == nil
        new_root = node.right
        node = nil
        new_root
      elsif node.right == nil
        new_root = node.is_left
        node = nil
        new_root
      else
        new_root = smallest_node(node.right)
        node.data = new_root.data
        node.right =  delete(new_root.data, node.right)
      end
    end
    node
  end

  def find(value, node = root)
    return if node == nil
    if value < node.data
      find(value, node.left)
    elsif value > node.data
      find(value, node.right)
    else
      node
    end
  end

  def level_order
    queue = Queue.new
    queue << root
    nodes_array = []
    while !queue.empty?
      current = queue.pop
      nodes_array << current
      queue << current.left if current.left
      queue << current.right if current.right
    end
    if block_given?
      nodes_array.map { |node| yield node }
    else
      nodes_array.map { |node| node.data }
    end
  end

  def inorder(node = root)
    return if node == nil
    inorder(node.left)
    puts node.data
    inorder(node.right)
  end

  def preorder(node = root)
    return if node == nil
    puts node.data
    preorder(node.left)
    preorder(node.right)
  end
  
  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  private
  def smallest_node(node)
    current = node
    while current.left != nil
      current = current.left
    end
    current
  end
end