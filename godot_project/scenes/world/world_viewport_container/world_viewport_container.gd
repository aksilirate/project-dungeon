class_name WorldViewportContainer extends SubViewportContainer



@onready var animation_player = $AnimationPlayer




func fade() -> void:
	animation_player.play("fade")

func unfade() -> void:
	animation_player.play("unfade")
