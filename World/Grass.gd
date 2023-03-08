extends Node2D

var grass_FX_scene = preload("res://World/GrassEffect.tscn")
var grass_FX

func create_grass_FX() -> void:
	grass_FX = grass_FX_scene.instance()
	grass_FX.set_position(self.position)
	get_tree().current_scene.add_child(grass_FX)

func _on_HurtBox_area_entered(_area: Area2D) -> void:
	create_grass_FX()
	queue_free()
