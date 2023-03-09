extends Camera2D

onready var top_left: Position2D = $Limits/TopLeft
onready var bottom_right: Position2D = $Limits/BottomRight

func _ready() -> void :
	limit_top = int(top_left.position.y)
	limit_left = int(top_left.position.x)
	limit_bottom = int(bottom_right.position.y)
	limit_right = int(bottom_right.position.x)
