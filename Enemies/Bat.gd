extends KinematicBody2D

class_name Bat

var knockback = Vector2.ZERO

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area: Area2D) -> void:
	knockback =  area.knockback_direction * 120
