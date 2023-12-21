@tool
class_name Appendage extends Node3D


@export var target_point: Marker3D

@onready var limbs: Array[Limb] = get_limbs()








func _process(delta: float) -> void:
	reset_pos()
	
	if get_max_length() < global_position.distance_to(target_point.global_position):
		for idx in limbs.size():
			var limb: Limb = limbs[idx]
			rotate_limb(limb, target_point.global_position, true)
			if not idx:
				continue
			var last_limb: Limb = limbs[idx - 1]
			limb.global_position = last_limb.end_segment.global_position
	
	
	for i in 10:
		var distance: float = get_distance_to_target()
		
		for idx in range(limbs.size() - 1, -1, -1):
			var limb: Limb = limbs[idx]
			
			if not idx == limbs.size() - 1:
				var last_limb: Limb = limbs[idx + 1]
				rotate_limb(limb, last_limb.global_position, true)
				limb.global_position = last_limb.global_position - (limb.end_segment.global_position - limb.global_position)
				continue
			
			rotate_limb(limb, target_point.global_position, true)
			limb.global_position = target_point.global_position - (limb.end_segment.global_position - limb.global_position)
		
		
		
		for idx in limbs.size():
			var limb: Limb = limbs[idx]
			
			if idx:
				var last_limb: Limb = limbs[idx - 1]
				rotate_limb(limb, last_limb.end_segment.global_position, false)
				limb.global_position = last_limb.end_segment.global_position
				continue
			
			rotate_limb(limb, global_position, false)
			limb.global_position = global_position
		
		
		#if abs(distance - get_distance_to_target()) > 0.4:
			#for idx in limbs.size():
				#reset_pos()
			#return

		distance = get_distance_to_target()


func reset_pos() -> void:
	for idx in limbs.size():
		var limb: Limb = limbs[idx]
		
		if not idx:
			limb.global_position = global_position
			continue
			
		var last_limb: Limb = limbs[idx - 1]
		limb.global_position = last_limb.end_segment.global_position




func rotate_limb(limb: Limb, look_pos: Vector3, inverse: bool) -> void:
	var direction: Vector3 = limb.global_position.direction_to(look_pos)
	var look_vector: Vector3 = limb.get_look_vector()
	var idx: int = limbs.find(limb)
	
	if not inverse:
		direction = limb.end_segment.global_position.direction_to(look_pos)
		look_vector = -look_vector
	
	var axis: Vector3 = direction.cross(look_vector).normalized()
	var angle: float = look_vector.signed_angle_to(direction, axis)
	
	if not is_equal_approx(angle, 0.0):
		limb.global_rotation = Basis(axis, angle).get_euler()
		#if not idx:
			#print(limb.global_rotation)
	
	
	var joint_limb: Limb = null
	var joint_basis: Basis = global_basis
	var joint_rot_min: Vector3 = limb.rot_min
	var joint_rot_max: Vector3 = limb.rot_max
	
	
	if not inverse:
		joint_limb = limb
		
		#if not idx:
			#joint_rot_min = global_basis * joint_rot_min
			#joint_rot_max = global_basis * joint_rot_max
		
		if idx:
			var last_limb: Limb = limbs[idx - 1]
			joint_limb = last_limb
			
			joint_rot_min += joint_limb.global_rotation_degrees
			joint_rot_max += joint_limb.global_rotation_degrees
			
			#print(joint_rot_min)
		
		
		#print(joint_rot_max)
	
	#if not idx:
		#print(limb.global_rotation_degrees)
	#limb.global_transform = limb.global_transform.translated(limb.global_position) * global_transform
	#
	#limb.global_rotation_degrees.x = clamp(limb.global_rotation_degrees.x, joint_rot_min.x, joint_rot_max.x)
	#limb.global_rotation_degrees.y = clamp(limb.global_rotation_degrees.y, joint_rot_min.y, joint_rot_max.y)
	#limb.global_rotation_degrees.z = clamp(limb.global_rotation_degrees.z, joint_rot_min.z, joint_rot_max.z)
	##print(limb.global_rotation_degrees)
	#
	#limb.global_transform = global_transform * limb.global_transform.translated(limb.global_position)
	
	#if not idx:
		#print(limb.global_rotation_degrees, " : ", global_rotation_degrees)






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
