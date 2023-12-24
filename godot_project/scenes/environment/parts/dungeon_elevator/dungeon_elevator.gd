class_name DungeonElevator extends Area3D


@export var platform: DungeonElevatorPlatform
@export var rope_beam: AnimatableBody3D



var time_to_decend: float = 1.5
var target_pos: float = 0
var try_to_descend: bool
var is_descending: bool



func _process(delta: float) -> void:
	if is_descending:
		return
	
	if try_to_descend:
		if time_to_decend <= 0.0:
			is_descending = true
			return
		
		time_to_decend -= delta
		return
	
	time_to_decend = 1.5


func _physics_process(delta: float) -> void:
	if is_descending:
		platform.position.y -= delta * 1.75
		rope_beam.rotation.z += delta * 1.25
		return
	
	platform.position.y = lerp(platform.position.y, target_pos, delta * 7.5)
