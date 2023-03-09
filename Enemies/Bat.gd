extends KinematicBody2D

class_name Bat

var death_FX_scene = preload("res://Effects/EnemyDeathEffect.tscn")
var death_FX
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite = $AnimatedSprite
onready var player_detection_zone: Area2D = $PlayerDetectionZone
onready var stats: Node = $Stats
onready var soft_collision: Area2D = $SoftCollision
onready var wander_controller: Node2D = $WanderController
onready var hurt_box: Area2D = $HurtBox

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
	state = pick_random_state([STATE.IDLE, STATE.WANDER])

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		STATE.IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				reset_state()
			
		STATE.WANDER:
			seek_player()
			if wander_controller.get_time_left() == 0:
				reset_state()
			go_to(wander_controller.target_position, delta)
			if global_position.distance_to(wander_controller.target_position) <= 4:
				reset_state()
			
		STATE.CHASE:
			chase(delta)
			
	var __ = move_and_slide(velocity)
	# Ewwwwwwwwwwwwwwwww

func go_to(position: Vector2, delta) -> void:
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	sprite.flip_h = velocity.x < 0

func reset_state() -> void:
	state = pick_random_state([STATE.IDLE, STATE.WANDER])
	wander_controller.start_timer(rand_range(1, 3))

func seek_player() -> void:
	if player_detection_zone.can_see_player():
		state = STATE.CHASE

func pick_random_state(state_list : Array) -> int:
	state_list.shuffle()
	return state_list.front()

func chase(delta) -> void:
	var player = player_detection_zone.player
	if player != null:
		go_to(player.global_position, delta)
		
		if soft_collision.is_colliding():
			velocity += soft_collision.get_push_vector() * delta * 400
		

func _create_death_FX() -> void:
	death_FX = death_FX_scene.instance()
	death_FX.set_position(self.position)
	get_parent().add_child(death_FX)

func _on_HurtBox_area_entered(area: Area2D) -> void:
	knockback =  area.knockback_direction * 120
	stats.health -= area.damage
	hurt_box.start_invincibility(0.4)

func _on_Stats_no_health() -> void:
	_create_death_FX()
	queue_free()

func _on_HurtBox_invincibility_started() -> void:
	animation_player.play("Start")

func _on_HurtBox_invincibility_ended() -> void:
	animation_player.play("Stop")
