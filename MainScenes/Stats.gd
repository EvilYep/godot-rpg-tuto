extends Node

class_name Stats

export var max_health : int = 1 setget set_max_health, get_max_health
onready var health :int = max_health setget set_health, get_health

signal no_health

func set_max_health(value: int) -> void:
	if max_health != value:
		max_health = value
func get_max_health() -> int: return max_health

func set_health(value: int) -> void:
	if health != value:
		health = value
		if health <= 0:
			emit_signal("no_health")
func get_health() -> int: return health
