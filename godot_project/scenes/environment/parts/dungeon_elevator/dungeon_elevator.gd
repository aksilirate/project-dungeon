class_name DungeonElevator extends Area3D


@export var platform: DungeonElevatorPlatform



var time_to_decend: float = 1.5
var target_pos: float = 0
var try_to_decend: bool
var is_decending: bool



func _process(delta: float) -> void:
	if is_decending:
		return
	
	if try_to_decend:
		if time_to_decend <= 0.0:
			is_decending = true
			return
		
		time_to_decend -= delta
		return
	
	time_to_decend = 1.5


func _physics_process(delta: float) -> void:
	if is_decending:
		platform.position.y -= delta * 1.75
		return
	
	platform.position.y = lerp(platform.position.y, target_pos, delta * 7.5)
