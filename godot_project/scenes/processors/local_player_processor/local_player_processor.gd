class_name LocalPlayerProcessor extends Processor





func _physics_process(_delta: float) -> void:
	process_target()




func process_target() -> void:
	for local_player in node_manager.local_player_arr:
		var closest_yot = null
		 
		for yot in node_manager.yot_arr:
			if yot.global_position.distance_to(local_player.global_position) > 5:
				continue
			
			var grim_distance: float = get_view_distance(local_player, yot)
			if grim_distance > -1 and grim_distance < 450:
				if not is_instance_valid(closest_yot):
					closest_yot = yot
					continue
				
				var closest_grim_distance: float = get_view_distance(local_player, closest_yot)
				if closest_grim_distance >= grim_distance:
					closest_yot = yot
		
		
		local_player.target = closest_yot




func get_view_distance(local_player: LocalPlayer, yot: Yot) -> float:
	var distance: float = local_player.global_position.distance_to(yot.global_position)
	var center_pos: Vector2 = get_viewport().size / 2
	
	if local_player.camera.is_position_behind(yot.global_position):
		return -1
	
	if distance > 2.0:
		return -1
	
	var space_state = local_player.get_world_3d().direct_space_state
	var physics_state = PhysicsRayQueryParameters3D.create(
		local_player.camera.global_position,
		yot.global_position + Vector3(0, 1.5, 0),
		0xFFFFFFFF,
		[local_player.get_rid()]
		)
	
	var result = space_state.intersect_ray(physics_state)
	
	var view_distance: Vector2 = local_player.camera.unproject_position(result["position"]) - center_pos
	return abs(view_distance.x) + (abs(view_distance.y) * 1.45)
