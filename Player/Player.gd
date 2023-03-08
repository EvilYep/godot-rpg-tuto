extends KinematicBody2D

class_name Player

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox = $HitboxPivot/SwordHitBox

const ACCELERATION := 500
const MAX_SPEED := 100
const ROLL_SPEED := 135
const FRICTION = 500

enum STATE {
	IDLE,
	RUN,
	ROLL,
	ATTACK
}

var state = STATE.RUN 
var direction := Vector2.ZERO setget set_direction, get_direction
var velocity : Vector2
var roll_vector : Vector2

#### ACCESSORS ####

func is_class(value: String): return value == "Player" or .is_class(value)
func get_class() -> String: return "Player"

func set_direction(value: Vector2) -> void:
	if direction != value:
		direction = value
func get_direction() -> Vector2: return direction

#### BUILT-IN ####

func _ready() -> void:
	animation_tree.active = true

func _process(_delta: float) -> void:
	match state :
		STATE.RUN:
			_move_state()
		STATE.ROLL:
			_roll_state()
		STATE.ATTACK:
			_attack_state()

#### VIRTUALS ####

#### LOGIC ####

func _move_state() -> void:
	direction = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	set_direction(direction.limit_length())
	
	if direction != Vector2.ZERO:
		roll_vector = direction
		sword_hitbox.knockback_direction = direction
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Run/blend_position", direction)
		animation_tree.set("parameters/Attack/blend_position", direction)
		animation_tree.set("parameters/Roll/blend_position", direction)
		animation_state.travel("Run")
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	
	_move()
	
	if Input.is_action_just_pressed("roll"):
		state = STATE.ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = STATE.ATTACK

func _roll_state() -> void:
	velocity = roll_vector * ROLL_SPEED
	animation_state.travel("Roll")
	_move()

func _attack_state() -> void:
	velocity = Vector2.ZERO
	animation_state.travel("Attack")

func _move() -> void:
	var __ = move_and_slide(velocity)

#### INPUTS ####

#### SIGNAL RESPONSES ####

func attack_animation_finished() -> void:
	velocity = velocity / 2
	state = STATE.RUN

func roll_animation_finished() -> void:
	state = STATE.RUN

# This code is ugly AF, I know
