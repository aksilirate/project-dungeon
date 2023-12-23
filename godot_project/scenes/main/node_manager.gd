class_name NodeManager extends Node



var dungeon_elevator_arr: Array[DungeonElevator] = []
var local_player_arr: Array[LocalPlayer] = []




func process_new_child(child: Node) -> void:
	child.child_entered_tree.connect(func(node: Node): process_new_child(node))
	var arr_ref: Array = []
	
	if child is DungeonElevator:
		arr_ref = dungeon_elevator_arr
	
	if child is LocalPlayer:
		arr_ref = local_player_arr
	
	child.tree_exiting.connect(func(): arr_ref.erase(child))
	arr_ref.push_back(child)
