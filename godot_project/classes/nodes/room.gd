class_name Room extends Node3D



@export var door_markers: Array[Marker3D]






func get_aabb() -> AABB:
	var aabb: AABB = AABB()
	
	for child in NodeUtils.get_all_children(self):
		if child is VisualInstance3D:
			var child_aabb: AABB = child.global_transform * child.get_aabb()
			child_aabb.position = (child_aabb.position * 100).round() / 100
			child_aabb.size = (child_aabb.size * 100).round() / 100
			if not child_aabb.size.x or not child_aabb.size.y or not child_aabb.size.z:
				continue
			
			if aabb.size == Vector3.ZERO:
				aabb = child_aabb
				continue
			
			aabb = aabb.merge(child_aabb)
	
	return aabb
