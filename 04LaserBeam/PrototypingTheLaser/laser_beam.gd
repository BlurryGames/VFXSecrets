class_name LaserBeam extends RayCast2D

@export var cast_speed: float = 7_000.0
@export var max_lenght: float = 1_400.0

@onready var fill: Line2D = %FillLine2D

func _physics_process(delta: float) -> void:
	target_position += (Vector2.RIGHT * cast_speed * delta).clampf(0.0, max_lenght)
	cast_beam()

func cast_beam() -> void:
	var cast_point: Vector2 = get_target_position()
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
	fill.points[1] = cast_point
