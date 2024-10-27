class_name AnimatedGhostTrail extends Sprite2D

const FADING_SPRITE: PackedScene = preload("res://03GhostTrail/GhostTrailEffect/animated_ghost_trail.tscn")

@export_range(0, 20, 1) var amount: int = 10

@export var is_emitting: bool = false:
	set = set_is_emitting

@onready var _timer: Timer = %GhostSpawnTimer

func set_is_emitting(value: bool) -> void:
	is_emitting = value
	if not is_inside_tree():
		await ready
	
	if is_emitting:
		_spawn_ghost()
		_timer.start(1.0 / amount)
	else:
		_timer.stop()

func _spawn_ghost() -> void:
	var ghost: Node = FADING_SPRITE.instantiate()
	ghost.set_texture(get_texture())
	ghost.set_offset(get_offset())
	ghost.set_flip_h(is_flipped_h())
	ghost.set_flip_v(is_flipped_v())
	ghost.set_global_position(get_global_position())
	
	add_child(ghost)
	ghost.set_as_top_level(true)

func _on_ghost_spawn_timer_timeout() -> void:
	_spawn_ghost()
