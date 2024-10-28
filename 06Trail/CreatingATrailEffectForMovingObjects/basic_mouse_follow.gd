class_name BasicMouseFollow extends Sprite2D

@export_range(-1_000, 1_000, 0.1) var speed: float = 300.0

var _direction := Vector2.RIGHT

func _process(delta: float) -> void:
	_direction = get_global_position().direction_to(get_global_mouse_position())
	set_rotation(_direction.angle())
	translate((_direction * speed) * delta)
