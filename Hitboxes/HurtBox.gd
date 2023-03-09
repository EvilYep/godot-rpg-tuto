extends Area2D

export(bool) var show_hit = true
export(Vector2) var offset = Vector2.ZERO

onready var timer: Timer = $Timer
var hit_FX_scene = preload("res://Effects/HitEffect.tscn")
var hit_FX
var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended

func set_invincible(value: bool) -> void:
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func start_invincibility(duration) -> void:
	self.invincible = true
	timer.start(duration)

func create_hit_effect() -> void:
	hit_FX = hit_FX_scene.instance()
	hit_FX.set_global_position(global_position + offset)
	get_tree().current_scene.add_child(hit_FX)

func _on_HurtBox_area_entered(_area: Area2D) -> void:
	if show_hit:
		create_hit_effect()

func _on_Timer_timeout() -> void:
	self.invincible = false

func _on_HurtBox_invincibility_ended() -> void:
	set_deferred("monitorable", false)

func _on_HurtBox_invincibility_started() -> void:
	monitorable = true
