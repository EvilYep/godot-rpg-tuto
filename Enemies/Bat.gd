extends KinematicBody2D

class_name Bat

var death_FX_scene = preload("res://Effects/EnemyDeathEffect.tscn")
var death_FX

onready var stats: Node = $Stats

var knockback = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _create_death_FX() -> void:
	death_FX = death_FX_scene.instance()
	death_FX.set_position(self.position)
	get_parent().add_child(death_FX)

func _on_HurtBox_area_entered(area: Area2D) -> void:
	knockback =  area.knockback_direction * 120
	stats.health -= area.damage

func _on_Stats_no_health() -> void:
	_create_death_FX()
	queue_free()
