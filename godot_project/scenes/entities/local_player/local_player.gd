class_name LocalPlayer extends CharacterBody3D


@export var right_arm_ik: SkeletonIK3D
@export var left_arm_ik: SkeletonIK3D
@export var camera_target: Marker3D
@export var camera: Camera3D
@export var arms: Node3D

var look_sensitivity: float = 0.1
var movement_speed: float = 4.5
var bob_strength: float = 0.0




func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	right_arm_ik.start()
	left_arm_ik.start()





func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * look_sensitivity
		camera.rotation_degrees.x -= event.relative.y * look_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
		arms.rotation.x += event.relative.y * 0.0001
		arms.rotation.x = clamp(arms.rotation.x, -0.3, 0.3)
		
		arms.rotation.y += event.relative.x * 0.0001
		arms.rotation.y = clamp(arms.rotation.y, -0.3, 0.3)





func _process(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, camera_target.global_position, delta * 17.5)
	camera.rotation_degrees.y = rotation_degrees.y
	
	arms.rotation.y = lerp(arms.rotation.y, 0.0, delta * 2.5)
	arms.rotation.x = lerp(arms.rotation.x, 0.0, delta * 2.5)
	
	arms.position.y = (sin(Time.get_ticks_msec() * 0.01) * 0.00075 * bob_strength)
	
	bob_strength = lerp(bob_strength, abs(velocity.x) + abs(velocity.z), delta * 7.5)




func _physics_process(_delta: float) -> void:
	var input_dir: Vector3 = get_input_dir()
	velocity = get_move_force(input_dir)
	velocity = get_gravity()
	
	if input_dir.y:
		velocity.y = 10
	
	move_and_slide()








func get_move_force(input_dir: Vector3) -> Vector3:
	var input_vector: Vector2 = Vector2(input_dir.z, input_dir.x).normalized()
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






func get_gravity() -> Vector3:
	if not is_on_floor():
		return Vector3(velocity.x, velocity.y - 1, velocity.z)
	
	return velocity






func get_input_dir() -> Vector3:
	var horizontal_input: Vector2 = Vector2.ZERO
	horizontal_input.x = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward")
	horizontal_input.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return Vector3(horizontal_input.x, Input.is_action_just_pressed("jump"), horizontal_input.y)
