class_name LaserBeam extends RayCast2D

@export var cast_speed: float = 7_000.0
@export var max_lenght: float = 1_400.0
@export var growth_time: float = 0.1

var tween: Tween = null

var is_casting: bool = false:
	set = set_is_casting

@onready var fill: Line2D = %FillLine2D

@onready var line_with: float = fill.get_width()

func _ready() -> void:
	set_physics_process(false)
	fill.points[1] = Vector2.ZERO

func _physics_process(delta: float) -> void:
	target_position += (Vector2.RIGHT * cast_speed * delta).clampf(0.0, max_lenght)
	cast_beam()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		set_is_casting(true)
	elif event.is_action_released(&"ui_accept"):
		set_is_casting(false)

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	if is_casting:
		set_target_position(Vector2.ZERO)
		fill.points[1] = get_target_position()
		apper()
	else:
		dissapear()
	
	set_physics_process(is_casting)

func cast_beam() -> void:
	var cast_point: Vector2 = get_target_position()
	force_raycast_update()
	if is_colliding():
		cast_point = to_local(get_collision_point())
	
	fill.points[1] = cast_point

func apper() -> void:
	if tween and tween.is_running():
		tween.kill.call_deferred()
	
	tween = create_tween()
	tween.tween_property(fill, ^"width", line_with, growth_time * 2.0)

func dissapear() -> void:
	if tween and tween.is_running():
		tween.kill.call_deferred()
	
	tween = create_tween()
	tween.tween_property(fill, ^"width", 0.0, growth_time)
