class_name LightingJolt extends Line2D

@export_range(0.5, 3.0, 0.01) var spread_angle: float = PI / 4.0

@export_range(1, 36, 1) var segments: int = 12

@onready var sparks: GPUParticles2D = %Sparks

@onready var ray_cast: RayCast2D = %RayCast2D

func _ready() -> void:
	set_as_top_level(true)

func create(start: Vector2, end: Vector2) -> void:
	ray_cast.set_global_position(start)
	ray_cast.set_target_position(end - start)
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		end = ray_cast.get_collision_point()
	
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
