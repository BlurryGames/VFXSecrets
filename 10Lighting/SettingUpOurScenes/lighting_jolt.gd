class_name LightingJolt extends Line2D

@export_range(0.5, 3.0, 0.01) var spread_angle: float = PI / 4.0

@export_range(1, 36, 1) var segments: int = 12

@onready var sparks: GPUParticles2D = %Sparks

func _ready() -> void:
	set_as_top_level(true)

func create(start: Vector2, end: Vector2) -> void:
	var _points: Array[Vector2] = []
	var current: Vector2 = start
	var segment_lenght: float = start.distance_to(end) / segments
	
	_points.append(start)
	for segment in range(segments):
		var _rotation: float = randf_range(-spread_angle * 0.5, spread_angle * 0.5)
		var _new: Vector2 = current + (current.direction_to(end) * segment_lenght).rotated(_rotation)
		_points.append(_new)
		
		current = _new
	
	_points.append(end)
	set_points(_points)
	sparks.set_global_position(end)
