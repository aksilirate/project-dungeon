class_name DungeonGenerator extends Node3D



@export var rooms: Array[PackedScene] = []
@export var elevator_room_scene: PackedScene
@export var spawn_room_scene: PackedScene

var closed_rooms: Array[PackedScene] = []
var open_rooms: Array[PackedScene] = []

var used_door_markers: Array[Marker3D] = []
var spawned_rooms: Array[Room] = []
var room_aabbs: Array[AABB] = []
var spawned_elevator_room: bool

var rand := RandomNumberGenerator.new()




func _ready() -> void:
	for room in rooms:
		var room_instance: Room = room.instantiate()
		room_instance.queue_free()
		
		if room_instance.door_markers.size() == 1:
			closed_rooms.push_back(room)
			continue
		
		open_rooms.push_back(room)
	
	generate()



func generate() -> void:
	spawned_elevator_room = false
	used_door_markers.clear()
	spawned_rooms.clear()
	room_aabbs.clear()
	
	rand.randomize()
	print("seed: ", rand.seed)
	
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	setup_spawn()
	generate_rooms()


func setup_spawn() -> void:
	var spawn_room: SpawnRoom = spawn_room_scene.instantiate()
	var local_player: LocalPlayer = preload("res://scenes/entities/local_player/local_player.tscn").instantiate()
	add_child(spawn_room)
	save_room(spawn_room)
	
	
	add_child(local_player)
	
	local_player.global_position = spawn_room.spawn_marker.global_position




func generate_rooms() -> void:
	var idx: int = -1
	
	for room in spawned_rooms:
		idx += 1
		
		for door_marker in room.door_markers:
			if used_door_markers.has(door_marker):
				continue
				
			var new_room: Room
			if idx > 1 and not spawned_elevator_room:
				new_room = elevator_room_scene.instantiate() as Room
				if try_to_spawn_room(door_marker, new_room):
					spawned_elevator_room = true
					continue
			
			new_room = get_rand_room().instantiate() as Room
			try_to_spawn_room(door_marker, new_room)




func try_to_spawn_room(door_marker: Marker3D, new_room: Room) -> bool:
	add_child(new_room)
	
	for new_room_door_marker in new_room.door_markers:
		if connect_rooms(door_marker, new_room, new_room_door_marker):
			return true
	
	new_room.queue_free()
	return false



func get_rand_room() -> PackedScene:
	if not spawned_elevator_room:
		return open_rooms[rand.randi() % open_rooms.size()]
	
	return closed_rooms[rand.randi() % closed_rooms.size()]





func save_room(room: Room) -> void:
	room_aabbs += room.get_aabb_arr()
	spawned_rooms.push_back(room)



func connect_rooms(base_marker: Marker3D, connected_room: Room, connected_marker: Marker3D) -> bool:
	used_door_markers.push_back(connected_marker)
	used_door_markers.push_back(base_marker)
	
	var difference: Vector3 = base_marker.global_position - connected_marker.global_position
	connected_room.global_position += difference
	
	var tries: int = 0
	while aabb_intersects(connected_room.get_aabb_arr()):
		tries += 1
		connected_room.rotation_degrees.y += 90
		difference = base_marker.global_position - connected_marker.global_position
		connected_room.global_position += difference
		
		if tries >= 4:
			used_door_markers.erase(connected_marker)
			used_door_markers.erase(base_marker)
			return false
	
	save_room(connected_room)
	
	return true



func aabb_intersects(room_aabb_arr: Array[AABB]) -> bool:
	for aabb in room_aabbs:
		for ref_aabb in room_aabb_arr:
			if aabb.intersects(ref_aabb):
				return true
	
	return false
