@tool
extends Node3D


func _ready() -> void:
	JoltPhysicsServer3D.set_active(true)
	PhysicsServer3D.set_active(true)
	#return
	#JoltPhysicsServer3D.set_active(true)
	#PhysicsServer3D.set_active(true)
	#print(".")
