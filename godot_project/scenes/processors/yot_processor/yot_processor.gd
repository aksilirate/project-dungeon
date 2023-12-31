class_name YotProcessor extends Processor






func _physics_process(_delta: float) -> void:
	for yot in node_manager.yot_arr:
		for local_player in node_manager.local_player_arr:
			yot.target = local_player
