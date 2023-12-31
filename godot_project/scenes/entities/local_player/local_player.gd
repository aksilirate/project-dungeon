class_name LocalPlayer extends EntityBody


@export var arms_animation_player: AnimationPlayer
@export var crosshair_texture_rect: TextureRect
@export var right_arm_ik: SkeletonIK3D
@export var left_arm_ik: SkeletonIK3D
@export var camera_target: Marker3D
@export var arms_offset: Node3D
@export var camera: Camera3D

var look_sensitivity: float = 0.1
var bob_strength: float = 0.0
var target: EntityBody = null



func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	right_arm_ik.start()
	left_arm_ik.start()





func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * look_sensitivity
		camera_target.rotation_degrees.x -= event.relative.y * look_sensitivity
		camera_target.rotation.x = clamp(camera_target.rotation.x, -PI/2, PI/2)
	
		arms_offset.rotation.x += event.relative.y * 0.0001
		arms_offset.rotation.x = clamp(arms_offset.rotation.x, -0.3, 0.3)
		
		arms_offset.rotation.y += event.relative.x * 0.0001
		arms_offset.rotation.y = clamp(arms_offset.rotation.y, -0.3, 0.3)
	
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("attack"):
			arms_animation_player.stop()
			arms_animation_player.play("duel_wield_attack")




func _process(delta: float) -> void:
	arms_offset.rotation.y = lerp(arms_offset.rotation.y, 0.0, delta * 2.5)
	arms_offset.rotation.x = lerp(arms_offset.rotation.x, 0.0, delta * 2.5)
	
	arms_offset.position.y = (sin(Time.get_ticks_msec() * 0.01) * 0.00075 * bob_strength)
	bob_strength = lerp(bob_strength, abs(velocity.x) + abs(velocity.z), delta * 7.5)




func _physics_process(delta: float) -> void:
	input_dir = get_input_dir()
	
	process_movement()
	process_camera_transform(delta)
	process_crosshair()






func process_camera_transform(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, camera_target.global_position, delta * 17.5)
	camera.rotation_degrees = camera_target.rotation_degrees
	camera.rotation_degrees.y = rotation_degrees.y





func process_crosshair() -> void:
	crosshair_texture_rect.position = get_viewport().size / 2
	crosshair_texture_rect.modulate = Color.WHITE
	
	if is_instance_valid(target):
		crosshair_texture_rect.position = camera.unproject_position(target.global_position + Vector3(0, 1.75, 0))
		crosshair_texture_rect.modulate = Color.RED






func get_input_dir() -> Vector3:
	var horizontal_input: Vector2 = Vector2.ZERO
	horizontal_input.x = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward")
	horizontal_input.y = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	return Vector3(horizontal_input.x, Input.is_action_just_pressed("jump"), horizontal_input.y)
