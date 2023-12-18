@tool
class_name Limb extends Node3D


@export var end_segment: Marker3D

@export_group("x")
@export_range(-360, 360) var x_rot_min: float = 0
@export_range(-360, 360) var x_rot_max: float = 0
@export_group("y")
@export_range(-360, 360) var y_rot_min: float = 0
@export_range(-360, 360) var y_rot_max: float = 0
@export_group("z")
@export_range(-360, 360) var z_rot_min: float = 0
@export_range(-360, 360) var z_rot_max: float = 0




func get_length() -> float:
	return end_segment.position.length()


func get_look_vector() -> Vector3:
	return end_segment.position.normalized()
