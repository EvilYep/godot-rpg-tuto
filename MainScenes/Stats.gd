extends Node

class_name Stats

export(int) var max_health = 4 setget set_max_health, get_max_health
var health :int = max_health setget set_health, get_health

signal health_changed(health)
signal max_health_changed(health)
signal no_health

func set_max_health(value: int) -> void:
	max_health = value
	self.health = int(min(health, max_health))
	emit_signal("max_health_changed", value)
func get_max_health() -> int: return max_health

func set_health(value: int) -> void:
	health = int(clamp(value, 0, max_health))
	emit_signal("health_changed", value)
	if health <= 0:
		emit_signal("no_health")
func get_health() -> int: return health

func _ready() -> void:
	self.health = max_health
