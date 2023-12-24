class_name NodeManager extends Node



var world_viewport_container_arr: Array[WorldViewportContainer] = []
var dungeon_elevator_arr: Array[DungeonElevator] = []
var local_player_arr: Array[LocalPlayer] = []





func process_new_child(child: Node) -> void:
	child.child_entered_tree.connect(func(node: Node): process_new_child(node))
	
	if child is WorldViewportContainer:
		add_to_array(child, world_viewport_container_arr)
		return
	
	if child is DungeonElevator:
		add_to_array(child, dungeon_elevator_arr)
		return
	
	if child is LocalPlayer:
		add_to_array(child, local_player_arr)
		return



func add_to_array(node: Node, array_ref: Array) -> void:
	node.tree_exiting.connect(func(): array_ref.erase(node))
	array_ref.push_back(node)
