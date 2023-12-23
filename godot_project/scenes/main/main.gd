class_name Main extends Node

@export var node_manager: NodeManager

@export var world: Node3D







func _ready() -> void:
	for child in NodeUtils.get_all_children(self, []):
		node_manager.process_new_child(child)
