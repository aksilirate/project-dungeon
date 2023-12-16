class_name NodeUtils










static func get_all_children(node: Node ,children: Array[Node] = []) -> Array[Node]:
	children.push_back(node)
	
	for child in node.get_children():
		children = get_all_children(child, children)
	
	return children
