class_name Client extends Node


@export var world: Node3D
@export var rooms: Array[PackedScene] = []

var used_door_markers: Array[Marker3D] = []
var spawned_rooms: Array[Room] = []
var room_aabbs: Array[AABB] = []





func _ready() -> void:
	setup_spawn()


func setup_spawn() -> void:
	var spawn_room: SpawnRoom = preload("res://scenes/environment/rooms/spawn_room/spawn_room.tscn").instantiate()
	var local_player: LocalPlayer = preload("res://scenes/entities/local_player/local_player.tscn").instantiate()
	world.add_child(spawn_room)
	save_room(spawn_room)
	
	
	world.add_child(local_player)
	
	local_player.global_position = spawn_room.spawn_marker.global_position
	
	
	for room in spawned_rooms:
		for door_marker in room.door_markers:
			if used_door_markers.has(door_marker):
				continue
			
			var new_room: Room = rooms.pick_random().instantiate() as Room
			world.add_child(new_room)
			
			for new_room_door_marker in new_room.door_markers:
				if await connect_rooms(room, door_marker, new_room, new_room_door_marker):
					break



func save_room(room: Room) -> void:
	room_aabbs.push_back(room.get_aabb())
	spawned_rooms.push_back(room)



func connect_rooms(base_room: Room, base_marker: Marker3D, connected_room: Room, connected_marker: Marker3D) -> bool:
	used_door_markers.push_back(connected_marker)
	used_door_markers.push_back(base_marker)
	
	var difference: Vector3 = base_marker.global_position - connected_marker.global_position
	connected_room.global_position += difference
	
	var tries: int = 0
	while aabb_intersects(connected_room.get_aabb()):
		await get_tree().create_timer(1.0).timeout
		#print(connected_room.get_aabb())
		tries += 1
		
		connected_room.rotation_degrees.y += 90
		difference = base_marker.global_position - connected_marker.global_position
		connected_room.global_position += difference
		
		
		if tries >= 10:
			used_door_markers.erase(connected_marker)
			used_door_markers.erase(base_marker)
			connected_room.queue_free()
			print("fuck")
			return false
	
	print("YES: ", connected_room.get_aabb(), base_room.get_aabb())
	save_room(connected_room)
	
	return true



func aabb_intersects(room_aabb: AABB) -> bool:
	for aabb in room_aabbs:
		if room_aabb.intersects(aabb):
			
			print(room_aabb, ":", aabb)
			return true
	
	return false
