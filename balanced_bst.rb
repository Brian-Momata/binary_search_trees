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

  def inorder(node = root, nodes_array = [])
    return if node == nil
    inorder(node.left, nodes_array)
    nodes_array << node
    inorder(node.right, nodes_array)
  
    return nodes_array.map { |node| yield node } if block_given?
    return nodes_array.map { |node| node.data }
  end

  def preorder(node = root, nodes_array = [])
    return if node == nil
    nodes_array << node
    preorder(node.left, nodes_array)
    preorder(node.right, nodes_array)

    return nodes_array.map { |node| yield node } if block_given?
    return nodes_array.map { |node| node.data }
  end

  def postorder(node = root, nodes_array = [])
    return if node == nil
    postorder(node.left, nodes_array)
    postorder(node.right, nodes_array)
    nodes_array << node

    return nodes_array.map { |node| yield node } if block_given?
    return nodes_array.map { |node| node.data }
  end

  def height(node = root)
    return -1 if node == nil
    left_height = height(node.left)
    right_height = height(node.right)

    left_height > right_height ? left_height + 1 : right_height + 1
  end

  def depth(value, node = root)
    if node == nil
      return
    elsif node.data == value
      return 0
    end
    left = depth(value, node.left)
    right = depth(value, node.right)
    return left + 1 if left
    return right + 1 if right
  end

  def balanced?(node = root)
    return true if node == nil
    left = height(node.left)
    right = height(node.right)
    if (left - right).abs <= 1 && balanced?(node.left) && balanced?(node.right)
      return true
    else
      return false
    end
  end

  def rebalance
    arr = self.inorder
    self.root = build_tree(arr)
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