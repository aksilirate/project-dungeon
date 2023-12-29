class_name WorldProcessor extends Node


@export var method_processor: MethodProcessor
@export var node_manager: NodeManager







func _physics_process(_delta: float) -> void:
	process_local_player()
	process_elevator()





func process_local_player() -> void:
	var center_pos: Vector2 = get_viewport().size / 2
	
	for local_player in node_manager.local_player_arr:
		var closest_grim = null
		 
		for grim in node_manager.grim_arr:
			if grim.global_position.distance_to(local_player.global_position) > 5:
				continue
			
			if local_player.camera.is_position_behind(grim.global_position):
				continue
			
			var grim_pos = grim.global_position
			if local_player.view_raycast.get_collider() == grim:
				grim_pos = local_player.view_raycast.get_collision_point()
			
			var distance: float = local_player.camera.unproject_position(grim.global_position).distance_to(center_pos)
			if distance < 500:
				closest_grim = grim
		
		local_player.target = closest_grim






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
