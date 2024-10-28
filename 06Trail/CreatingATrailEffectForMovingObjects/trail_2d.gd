@tool class_name Trail2D extends Line2D

@export_range(0.1, 10.0, 0.1) var lifetime: float = 0.5
@export_range(0.0, 100.0, 0.1) var resolution: float = 5.0

@export_range(1, 1000, 1) var max_points: int = 100

@export var target: Node2D = null:
	get:
		if not target:
			target = get_parent() as Node2D
		
		return target

@export var is_emitting: bool = false:
	set = set_emitting

var _points_creation_time: Array[float] = []

var _last_point := Vector2.ZERO

var _clock: float = 0.0
var _offset: float = 0.0

func _ready() -> void:
	if Engine.is_editor_hint():
		set_process(false)
		return
	
	_offset = get_position().length()
	clear_points()
	set_as_top_level(true)
	set_position(Vector2.ZERO)
	_last_point = to_local(target.get_global_position()) + calculate_offset()

func _process(delta: float) -> void:
	_clock += delta
	remove_older()
	
	var desired_point: Vector2 = to_local(target.get_global_position())
	var distance: float = _last_point.distance_to(desired_point)
	if distance > resolution:
		add_time_point(desired_point, _clock)

func _get_configuration_warnings() -> PackedStringArray:
	var warning: String = "" if target else "Missing Target node: assign a Node that extends Node2D in the Target or make the trail a child of a parent that extends Node2D"
	
	return PackedStringArray([warning])

func calculate_offset() -> Vector2:
	var target_rotation: float = target.get_rotation()
	var offset: Vector2 = (1.0 * Vector2(cos(target_rotation), sin(target_rotation))) * _offset
	
	return -offset

func add_time_point(point: Vector2, time: float) -> void:
	add_point(point + calculate_offset())
	_points_creation_time.append(time)
	_last_point = point
	if get_point_count() > max_points:
		remove_first_point()

func set_emitting(emitting: bool) -> void:
	is_emitting = emitting
	if Engine.is_editor_hint():
		return
	
	if not is_inside_tree():
		await ready
	
	if is_emitting:
		clear_points()
		_points_creation_time.clear()
		_last_point = to_local(target.get_global_position()) + calculate_offset()

func remove_first_point() -> void:
	if get_point_count() > 1:
		remove_point(0)
	
	_points_creation_time.pop_front()

func remove_older() -> void:
	for creation_time: float in _points_creation_time:
		var delta = _clock - creation_time
		if delta <= lifetime:
			break
		
		remove_first_point()
