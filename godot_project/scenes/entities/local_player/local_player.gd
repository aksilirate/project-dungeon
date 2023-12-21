class_name LocalPlayer extends CharacterBody3D



@export var floor_raycast: RayCast3D
@export var camera_target: Marker3D
@export var camera: Camera3D

var look_sensitivity: float = 0.1
var movement_speed: float = 4.5


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED




func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * look_sensitivity
		camera.rotation_degrees.x -= event.relative.y * look_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)




func _process(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, camera_target.global_position, delta * 17.5)
	camera.rotation_degrees.y = rotation_degrees.y




func _physics_process(delta: float) -> void:
	var input_dir: Vector3 = get_input_dir()
	velocity = get_move_force(input_dir)
	velocity = get_gravity()
	
	if input_dir.y:
		velocity.y = 10
	
	move_and_slide()
	
	velocity = get_pull_force(input_dir, delta)




func get_move_force(input_dir: Vector3) -> Vector3:
	var input_vector: Vector2 = Vector2(input_dir.z, input_dir.x).normalized()
	var horizontal_input: Vector2 = input_vector.rotated(-deg_to_rad(rotation_degrees.y))
	var move_force = Vector3(horizontal_input.x, velocity.y, horizontal_input.y)
	
	if floor_raycast.is_colliding():
		var normal: Vector3 = floor_raycast.get_collision_normal()
		move_force = normal.cross(Vector3.FORWARD.rotated(Vector3.UP, global_rotation.y - (PI / 2)))
		move_force = move_force.rotated(normal, input_vector.angle_to(Vector2.UP))
		move_force *= movement_speed * input_vector.length()
		return move_force
	
	
	return velocity




func get_gravity() -> Vector3:
	if not floor_raycast.is_colliding():
		return Vector3(velocity.x, velocity.y - 1, velocity.z)
	
	return Vector3(velocity.x, 0, velocity.z)




func get_pull_force(input_dir: Vector3, delta: float) -> Vector3:
	if input_dir.y:
		return velocity
	
	if floor_raycast.is_colliding():
		var pull_strength: float = floor_raycast.target_position.y + floor_raycast.global_position.distance_to(floor_raycast.get_collision_point())
		var pull_force: Vector3 = Vector3(velocity.x, -pull_strength / delta, velocity.z)
		return pull_force
	
	return velocity




func get_input_dir() -> Vector3:
	var horizontal_input: Vector2 = Vector2.ZERO
	horizontal_input.x = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward")
	horizontal_input.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return Vector3(horizontal_input.x, Input.is_action_just_pressed("jump"), horizontal_input.y)
