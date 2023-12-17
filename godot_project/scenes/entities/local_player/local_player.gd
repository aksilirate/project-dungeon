class_name LocalPlayer extends Node3D


@export var main_skeleton: Skeleton3D
@export var target_skeleton: Skeleton3D

@export var right_hand_bone: PhysicalBone3D
@export var head_bone: PhysicalBone3D
@export var root_bone: PhysicalBone3D

@export var floor_raycast: RayCast3D
@export var camera: Camera3D
@export var joints: Node3D


@onready var main_bones: Array[PhysicalBone3D] = get_bones(main_skeleton)
@onready var target_bones: Array[PhysicalBone3D] = get_bones(target_skeleton)

@export var sword: RigidBody3D

var camera_offset: Vector3 = Vector3(0, 0.45, 0)
var look_sensitivity: float = 0.1




func _ready() -> void:
	main_skeleton.physical_bones_start_simulation()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	for bone in main_bones:
		floor_raycast.add_exception(bone)
	
	#create_joints()
	
	sword.add_collision_exception_with(right_hand_bone)
	#create_pin_joint(right_hand_bone.get_path(), sword.get_path())
	init_ik()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_skeleton.rotation_degrees.z -= event.relative.x * look_sensitivity
		camera.rotation_degrees.x -= event.relative.y * look_sensitivity
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)


func _process(delta: float) -> void:
	camera.global_position = lerp(camera.global_position, head_bone.global_position + camera_offset, delta * 17.5)
	camera.rotation_degrees.y = target_skeleton.rotation_degrees.z



func _physics_process(delta: float) -> void:
	floor_raycast.global_position = head_bone.global_position
	
	if floor_raycast.is_colliding():
		var target_head_pos: Vector3 = floor_raycast.get_collision_point() - floor_raycast.target_position
		var distance: float = head_bone.global_position.distance_to(target_head_pos)
		head_bone.apply_impulse(Vector3.UP * distance * 10)
	
	
	head_bone.apply_impulse(-Vector3(head_bone.linear_velocity.x, 0, head_bone.linear_velocity.z))
	root_bone.apply_impulse(-Vector3(head_bone.linear_velocity.x, 0, head_bone.linear_velocity.z))
	head_bone.apply_impulse(get_move_dir() * 5)
	root_bone.apply_impulse(get_move_dir() * 5)
	



func init_ik() -> void:
	for child in main_skeleton.get_children():
		if child is SkeletonIK3D:
			child.start()



func create_joints() -> void:
	for idx in main_bones.size():
		var main_bone: PhysicalBone3D = main_bones[idx]
		var target_bone: PhysicalBone3D = target_bones[idx]
		create_spring_joint(main_bone.get_path(), target_bone.get_path())




func create_pin_joint(node_a: NodePath, node_b: NodePath) -> void:
	var pin_joint = JoltPinJoint3D.new()
	pin_joint.node_a = node_a
	pin_joint.node_b = node_b
	get_node(node_b).global_position = get_node(node_a).global_position
	get_node(node_a).add_child(pin_joint)



func create_spring_joint(node_a: NodePath, node_b: NodePath) -> void:
	var generic_6dof_joint = JoltGeneric6DOFJoint3D.new()
	generic_6dof_joint.set_flag_x(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, false)
	generic_6dof_joint.set_flag_y(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, false)
	generic_6dof_joint.set_flag_z(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_LIMIT, false)
	generic_6dof_joint.set_flag_x(JoltGeneric6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, false)
	generic_6dof_joint.set_flag_y(JoltGeneric6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, false)
	generic_6dof_joint.set_flag_z(JoltGeneric6DOFJoint3D.FLAG_ENABLE_ANGULAR_LIMIT, false)
	
	generic_6dof_joint.set_flag_x(JoltGeneric6DOFJoint3D.FLAG_ENABLE_ANGULAR_SPRING, true)
	generic_6dof_joint.set_flag_y(JoltGeneric6DOFJoint3D.FLAG_ENABLE_ANGULAR_SPRING, true)
	generic_6dof_joint.set_flag_z(JoltGeneric6DOFJoint3D.FLAG_ENABLE_ANGULAR_SPRING, true)
	
	generic_6dof_joint.set_param_x(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_SPRING_FREQUENCY, 45)
	generic_6dof_joint.set_param_y(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_SPRING_FREQUENCY, 45)
	generic_6dof_joint.set_param_z(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_SPRING_FREQUENCY, 45)
	
	generic_6dof_joint.set_param_x(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_SPRING_DAMPING, 25)
	generic_6dof_joint.set_param_y(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_SPRING_FREQUENCY, 25)
	generic_6dof_joint.set_param_z(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_SPRING_FREQUENCY, 25)
	
	generic_6dof_joint.node_a = node_a
	generic_6dof_joint.node_b = node_b
	joints.add_child(generic_6dof_joint)



func get_bones(skeleton: Skeleton3D) -> Array[PhysicalBone3D]:
	var main_bones: Array[PhysicalBone3D] = []
	
	for child in skeleton.get_children():
		if child is PhysicalBone3D:
			main_bones.push_back(child)
	
	return main_bones










#@export var follow_skeleton: Skeleton3D
#@export var ik_nodes: Array[SkeletonIK3D]
#@export var floor_raycast: RayCast3D
#@export var camera_target_pos: Node3D
#@export var camera: Camera3D
#
#
#
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
#var look_sensitivity: float = 0.1
#
#
#
#func _ready() -> void:
	#
	#follow_skeleton.physical_bones_start_simulation()
	#for ik_node in ik_nodes:
		#ik_node.start()
#
#
#func _unhandled_input(event):
	#if event is InputEventMouseMotion:
		#camera.rotation_degrees.y -= event.relative.x * look_sensitivity

#
#
#func _process(delta: float) -> void:
	#
	#
	#floor_raycast.global_position = global_position
#
#
#
#
#
#func _integrate_forces(_state: PhysicsDirectBodyState3D) -> void:
	#if floor_raycast.is_colliding():
		#var distance: float = floor_raycast.global_position.distance_to(floor_raycast.get_collision_point())
		#distance = abs(floor_raycast.target_position.y) - distance
		#distance = clamp(distance, 0, abs(floor_raycast.target_position.y))
		#linear_velocity.y = distance * 15
	#
	#var velocity = get_move_dir() * 3.5
	#linear_velocity.x = velocity.x
	#linear_velocity.z = velocity.z





func get_move_dir() -> Vector3:
	var input_dir: Vector3 = get_input_dir()
	
	var input_vector: Vector2 = Vector2(input_dir.z, input_dir.x)
	var horizontal_move_dir: Vector2 = input_vector.rotated(-deg_to_rad(target_skeleton.rotation_degrees.z))
	
	var move_dir: Vector3 = Vector3(horizontal_move_dir.x, 0, horizontal_move_dir.y)
	
	return move_dir



func get_input_dir() -> Vector3:
	var horizontal_input: Vector2 = Vector2.ZERO
	horizontal_input.x = Input.get_action_strength("move_backwards") - Input.get_action_strength("move_forward")
	horizontal_input.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var input_dir: Vector3 = Vector3(horizontal_input.x, 0, horizontal_input.y)
	return input_dir
