extends Area2D

export(bool) var show_hit = true
export(Vector2) var offset = Vector2.ZERO

var hit_FX_scene = preload("res://Effects/HitEffect.tscn")
var hit_FX

func _on_HurtBox_area_entered(_area: Area2D) -> void:
	if show_hit:
		hit_FX = hit_FX_scene.instance()
		hit_FX.set_global_position(global_position + offset)
		get_tree().current_scene.add_child(hit_FX)
