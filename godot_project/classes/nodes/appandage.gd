@tool
class_name Appendage extends Node3D


@export var target_point: Marker3D

@onready var limbs: Array[Limb] = get_limbs()








func _process(delta: float) -> void:
	for idx in limbs.size():
		var limb: Limb = limbs[idx]
		
		if idx:
			var last_limb: Limb = limbs[idx - 1]
			limb.global_position = last_limb.end_segment.global_position
			continue
		
		limb.global_position = global_position
	
	
	if get_max_length() < global_position.distance_to(target_point.global_position):
		for idx in limbs.size():
			var limb: Limb = limbs[idx]
			await rotate_limb(limb, target_point.global_position, false)
		return
	
	var last_transforms: Array[Transform3D] = get_limb_transforms()
	
	
	
	for i in 10:
		var distance: float = get_distance_to_target()
		
		for idx in range(limbs.size() - 1, -1, -1):
				var limb: Limb = limbs[idx]
				
				if not idx == limbs.size() - 1:
					var last_limb: Limb = limbs[idx + 1]
					rotate_limb(limb, last_limb.global_position, false)
					limb.global_position = last_limb.global_position - (limb.end_segment.global_position - limb.global_position)
					continue
				
				rotate_limb(limb, target_point.global_position, false)
				limb.global_position = target_point.global_position - (limb.end_segment.global_position - limb.global_position)
		
		
		for idx in limbs.size():
			var limb: Limb = limbs[idx]
			
			if idx:
				var last_limb: Limb = limbs[idx - 1]
				rotate_limb(limb, last_limb.end_segment.global_position, true)
				limb.global_position = last_limb.end_segment.global_position
				continue
			
			rotate_limb(limb, global_position, true)
			limb.global_position = global_position
		
		
		if abs(distance - get_distance_to_target()) > 0.4:
			return
			#for idx in limbs.size():
				#limbs[idx].global_transform = last_transforms[idx]
		
		last_transforms = get_limb_transforms()
		distance = get_distance_to_target()





func rotate_limb(limb: Limb, look_pos: Vector3, inverse: bool) -> void:
	var direction: Vector3 = limb.global_position.direction_to(look_pos)
	var look_vector: Vector3 = limb.get_look_vector()
	var idx: int = limbs.find(limb)
	
	if inverse:
		direction = limb.end_segment.global_position.direction_to(look_pos)
		look_vector = -look_vector
	
	var axis: Vector3 = direction.cross(look_vector).normalized()
	var angle: float = look_vector.signed_angle_to(direction, axis)
	
	
	if not axis == Vector3.ZERO:
		var rotation_diff = Quaternion(axis, angle).get_euler() - limb.global_rotation
		limb.global_rotation += rotation_diff
		
		var clamp_offset: Vector3 = Vector3.ZERO
		
		if idx:
			var last_limb: Limb = limbs[idx - 1]
			clamp_offset = last_limb.global_rotation_degrees
		
		var x_clamp: float = clamp(limb.global_rotation_degrees.x, limb.x_rot_min + clamp_offset.x, limb.x_rot_max + clamp_offset.x)
		var y_clamp: float = clamp(limb.global_rotation_degrees.y, limb.y_rot_min + clamp_offset.y, limb.y_rot_max + clamp_offset.y)
		var z_clamp: float = clamp(limb.global_rotation_degrees.z, limb.z_rot_min + clamp_offset.z, limb.z_rot_max + clamp_offset.z)
		limb.global_rotation_degrees = Vector3(x_clamp, y_clamp, z_clamp)




func get_limb_transforms() -> Array[Transform3D]:
	var limb_transforms: Array[Transform3D] = []
	for limb in limbs:
		limb_transforms.push_back(limb.get_global_transform())
	return limb_transforms

func get_max_length() -> float:
	var max_length: float = 0
	
	for limb in limbs:
		max_length += limb.get_length()
	
	return max_length




func get_limbs() -> Array[Limb]:
	var limbs: Array[Limb] = []
	
	for child in get_children():
		if child is Limb:
			limbs.push_back(child)
	
	return limbs



func get_distance_to_target() -> float:
	return (limbs.back() as Limb).end_segment.global_position.distance_to(target_point.global_position)
