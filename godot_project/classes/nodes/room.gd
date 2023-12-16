class_name Room extends Node3D



@export var door_markers: Array[Marker3D]



func get_aabb() -> AABB:
	var aabb = AABB()
	
	for child in NodeUtils.get_all_children(self):
		if child is VisualInstance3D:
			var child_aabb: AABB = child.get_aabb()
			child_aabb.position += child.position
			child_aabb.size = (child.global_transform.basis * child_aabb.size).abs()
			aabb = aabb.merge(child_aabb)
	
	aabb.size = (aabb.size * 10).floor() / 10
	aabb.position = global_position
	return aabb
