extends KinematicBody2D

class_name Player

const ACCELERATION := 500
const MAX_SPEED := 100
const FRICTION = 500

var moving_direction := Vector2.ZERO setget set_moving_direction, get_moving_direction
var velocity : Vector2

#### ACCESSORS ####

func is_class(value: String): return value == "Player" or .is_class(value)
func get_class() -> String: return "Player"

func set_moving_direction(value: Vector2) -> void:
	if moving_direction != value:
		moving_direction = value
func get_moving_direction() -> Vector2: return moving_direction

#### BUILT-IN ####

func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	var dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	set_moving_direction(dir.limit_length())

func _physics_process(delta: float) -> void:
	if moving_direction != Vector2.ZERO:
		velocity = velocity.move_toward(moving_direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	var __ = move_and_slide(velocity)

#### VIRTUALS ####

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
