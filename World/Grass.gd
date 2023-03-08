extends Node2D

var grass_FX_scene = preload("res://World/GrassEffect.tscn")
var grass_FX

func _ready() -> void:
	grass_FX = grass_FX_scene.instance()
	grass_FX.set_position(self.position)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		get_tree().current_scene.add_child(grass_FX)
		queue_free()
