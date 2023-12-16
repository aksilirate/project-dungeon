class_name LocalPlayer extends CharacterBody3D


@export var camera_target_pos: Node3D
@export var camera: Camera3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity: float = 0.1



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera.rotation_degrees.y -= event.relative.x * look_sensitivity
		camera.rotation_degrees.x -= event.relative.y * look_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)


func _process(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, camera_target_pos.global_position, delta * 17.5)


func _physics_process(delta: float) -> void:
	velocity = get_move_dir() * 4.5
	move_and_slide()





func get_move_dir() -> Vector3:
	var input_dir: Vector3 = get_input_dir()
	
	var input_vector: Vector2 = Vector2(input_dir.z, input_dir.x)
	var horizontal_move_dir: Vector2 = input_vector.rotated(-deg_to_rad(camera.rotation_degrees.y))
	
	var move_dir: Vector3 = Vector3(horizontal_move_dir.x, 0, horizontal_move_dir.y)
	
	return move_dir



func get_input_dir() -> Vector3:
	var horizontal_input: Vector2 = Vector2.ZERO
	horizontal_input.x = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward")
	horizontal_input.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var input_dir: Vector3 = Vector3(horizontal_input.x, 0, horizontal_input.y)
	return input_dir
