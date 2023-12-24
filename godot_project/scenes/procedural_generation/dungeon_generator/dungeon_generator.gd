class_name DungeonGenerator extends Node3D



@export var rooms: Array[PackedScene] = []

var used_door_markers: Array[Marker3D] = []
var spawned_rooms: Array[Room] = []
var room_aabbs: Array[AABB] = []

var rand := RandomNumberGenerator.new()




func _ready() -> void:
	print("seed: ", rand.seed)
	setup_spawn()




func setup_spawn() -> void:
	var spawn_room: SpawnRoom = preload("res://scenes/environment/rooms/spawn_room/spawn_room.tscn").instantiate()
	var local_player: LocalPlayer = preload("res://scenes/entities/local_player/local_player.tscn").instantiate()
	add_child(spawn_room)
	save_room(spawn_room)
	
	
	add_child(local_player)
	
	local_player.global_position = spawn_room.spawn_marker.global_position
	
	
	for room in spawned_rooms:
		for door_marker in room.door_markers:
			if used_door_markers.has(door_marker):
				continue
			
			var new_room: Room = get_rand_room().instantiate() as Room
			add_child(new_room)
			
			var failed: bool = true
			for new_room_door_marker in new_room.door_markers:
				if connect_rooms(door_marker, new_room, new_room_door_marker):
					failed = false
					break
			
			if failed:
				new_room.queue_free()




func get_rand_room() -> PackedScene:
	var idx: int = rand.randi() % rooms.size()
	return rooms[idx]


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
