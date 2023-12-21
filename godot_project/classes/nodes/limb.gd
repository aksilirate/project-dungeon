@tool
class_name Limb extends Node3D


@export var end_segment: Marker3D

@export var rot_min: Vector3
@export var rot_max: Vector3




func get_length() -> float:
	return end_segment.position.length()


func get_look_vector() -> Vector3:
	return end_segment.position.normalized()
