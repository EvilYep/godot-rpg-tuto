extends KinematicBody2D

class_name Bat

var death_FX_scene = preload("res://Effects/EnemyDeathEffect.tscn")
var death_FX
onready var sprite = $AnimatedSprite
onready var player_detection_zone: Area2D = $PlayerDetectionZone
onready var stats: Node = $Stats
onready var soft_collision: Area2D = $SoftCollision

export var acceleration := 300
export var max_speed := 50
export var friction := 200

enum STATE {
	IDLE,
	WANDER,
	CHASE
}

var state = STATE.IDLE
var velocity := Vector2.ZERO
var knockback = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		STATE.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		STATE.WANDER:
			pass
		STATE.CHASE:
			chase(delta)
			
	# Ewwwwwwwwww

func seek_player() -> void:
	if player_detection_zone.can_see_player():
		state = STATE.CHASE

func chase(delta) -> void:
	var player = player_detection_zone.player
	if player != null:
		var direction = (player.global_position - global_position).normalized()
		velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		
		sprite.flip_h = velocity.x < 0
		
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * delta * 400
		
		var __ = move_and_slide(velocity)

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
