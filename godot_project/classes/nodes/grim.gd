class_name Yot extends EntityBody







var target: EntityBody




func _physics_process(_delta: float) -> void:
	process_movement()
	
	if is_instance_valid(target):
		input_dir = global_position.direction_to(target.global_position)
		input_dir.y = 0
