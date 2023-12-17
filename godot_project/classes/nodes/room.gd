class_name Room extends Node3D



@export var door_markers: Array[Marker3D]
@export var collision: CollisionShape3D






func get_aabb() -> AABB:
	var fixed_aabb: AABB = global_transform * AABB(collision.position, (collision.shape as BoxShape3D).size)
	fixed_aabb.position = (fixed_aabb.position * 100).round() / 100
	fixed_aabb.size = ((fixed_aabb.size * 10).round() / 10).abs()
	return fixed_aabb



