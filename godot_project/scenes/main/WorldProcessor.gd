class_name WorldProcessor extends Node


@export var node_manager: NodeManager







func _physics_process(_delta: float) -> void:
	process_elevator()





func process_elevator() -> void:
	for dungeon_elevator in node_manager.dungeon_elevator_arr:
		dungeon_elevator.try_to_decend = false
		dungeon_elevator.target_pos = 0
		
		for overlapping_body in dungeon_elevator.get_overlapping_bodies():
			if overlapping_body is LocalPlayer:
				if not overlapping_body.is_on_floor():
					continue
				
				dungeon_elevator.try_to_decend = true
				dungeon_elevator.target_pos = -0.15
			
			if dungeon_elevator.is_decending:
				for world_viewport_container in node_manager.world_viewport_container_arr:
					world_viewport_container.fade()
