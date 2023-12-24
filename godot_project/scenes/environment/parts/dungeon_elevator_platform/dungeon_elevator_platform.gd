class_name DungeonElevatorPlatform extends AnimatableBody3D



@export var rope: MeshInstance3D



func _ready() -> void:
	(rope.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("height", global_position.y)
