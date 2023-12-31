class_name YotProcessor extends Node




@export var method_processor: MethodProcessor
@export var node_manager: NodeManager




func _physics_process(delta: float) -> void:
	for yot in node_manager.yot_arr:
		for local_player in node_manager.local_player_arr:
			yot.target = local_player
