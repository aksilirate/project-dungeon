class_name EntityBody extends CharacterBody3D




var movement_speed: float = 4.5
var input_dir: Vector3






func process_movement() -> void:
	velocity = get_move_force()
	velocity = get_gravity()
	
	if input_dir.y and is_on_floor():
		velocity.y = 15
	
	move_and_slide()




func get_gravity() -> Vector3:
	if not is_on_floor():
		return Vector3(velocity.x, velocity.y - 1, velocity.z)
	
	return velocity




func get_move_force() -> Vector3:
	var input_vector: Vector2 = Vector2(-input_dir.z, input_dir.x).normalized()
	var horizontal_input: Vector2 = input_vector.rotated(-deg_to_rad(rotation_degrees.y))
	var move_force = Vector3(horizontal_input.x, velocity.y, horizontal_input.y)
	
	if is_on_floor():
		var normal: Vector3 = get_floor_normal()
		move_force = normal.cross(Vector3.FORWARD.rotated(Vector3.UP, global_rotation.y - (PI / 2)))
		move_force = move_force.rotated(normal, input_vector.angle_to(Vector2.UP))
		move_force *= movement_speed * input_vector.length()
		return move_force
	
	move_force.x *= movement_speed * input_vector.length()
	move_force.z *= movement_speed * input_vector.length()
	return move_force
