class_name EntityBodyProcessor extends Processor










func _physics_process(_delta: float) -> void:
	for entity_body in node_manager.entity_body_arr:
		entity_body.process_movement()
