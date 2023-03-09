extends AnimatedSprite

func _ready() -> void:
	var __ = connect("animation_finished", self, "_on_animation_finished")
	play("play_FX")

func _on_animation_finished() -> void:
	queue_free()
