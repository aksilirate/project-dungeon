class_name WorldProcessor extends Node


@export var method_processor: MethodProcessor
@export var node_manager: NodeManager







func _physics_process(_delta: float) -> void:
	process_local_player_target()
	process_elevator()





func process_local_player_target() -> void:
	for local_player in node_manager.local_player_arr:
		var closest_grim = null
		 
		for grim in node_manager.grim_arr:
			if grim.global_position.distance_to(local_player.global_position) > 5:
				continue
			
			var grim_distance: float = get_view_distance(local_player, grim)
			if grim_distance > -1 and grim_distance < 450:
				if not is_instance_valid(closest_grim):
					closest_grim = grim
					continue
				
				var closest_grim_distance: float = get_view_distance(local_player, closest_grim)
				if closest_grim_distance >= grim_distance:
					closest_grim = grim
		
		
		local_player.target = closest_grim




func get_view_distance(local_player: LocalPlayer, grim: Grim) -> float:
	var distance: float = local_player.global_position.distance_to(grim.global_position)
	var center_pos: Vector2 = get_viewport().size / 2
	
	if local_player.camera.is_position_behind(grim.global_position):
		return -1
	
	if distance > 2.0:
		return -1
	
	var space_state = local_player.get_world_3d().direct_space_state
	var physics_state = PhysicsRayQueryParameters3D.create(
		local_player.camera.global_position,
		grim.global_position + Vector3(0, 1.5, 0),
		0xFFFFFFFF,
		[local_player.get_rid()]
		)
	
	var result = space_state.intersect_ray(physics_state)
	
	var view_distance: Vector2 = local_player.camera.unproject_position(result["position"]) - center_pos
	return abs(view_distance.x) + (abs(view_distance.y) * 1.45)





func process_elevator() -> void:
	for dungeon_elevator in node_manager.dungeon_elevator_arr:
		dungeon_elevator.try_to_descend = false
		dungeon_elevator.target_pos = 0
		
		for overlapping_body in dungeon_elevator.get_overlapping_bodies():
			if overlapping_body is LocalPlayer:
				if not overlapping_body.is_on_floor():
					continue
				
				dungeon_elevator.try_to_descend = true
				dungeon_elevator.target_pos = -0.15
			
			if dungeon_elevator.is_descending:
				method_processor.call_method(descend, [])




func descend() -> void:
	for world_viewport_container in node_manager.world_viewport_container_arr:
		world_viewport_container.fade()
		
	await get_tree().create_timer(5.75).timeout
	for dungeon_generator in node_manager.dungeon_generator_arr:
		dungeon_generator.generate()
	
	for world_viewport_container in node_manager.world_viewport_container_arr:
		world_viewport_container.unfade()
