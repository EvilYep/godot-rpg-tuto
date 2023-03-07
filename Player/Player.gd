extends KinematicBody2D

class_name Player

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var animation_tree: AnimationTree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

const ACCELERATION := 500
const MAX_SPEED := 100
const FRICTION = 500

var direction := Vector2.ZERO setget set_direction, get_direction
var velocity : Vector2

#### ACCESSORS ####

func is_class(value: String): return value == "Player" or .is_class(value)
func get_class() -> String: return "Player"

func set_direction(value: Vector2) -> void:
	if direction != value:
		direction = value
func get_direction() -> Vector2: return direction

#### BUILT-IN ####

func _ready() -> void:
	pass

func _input(_event: InputEvent) -> void:
	var dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	set_direction(dir.limit_length())
	
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Run/blend_position", direction)
		animation_state.travel("Run")
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

func _physics_process(_delta: float) -> void:
	var __ = move_and_slide(velocity)

#### VIRTUALS ####

#### LOGIC ####

#### INPUTS ####

#### SIGNAL RESPONSES ####
