class_name LightingBeam extends RayCast2D

const LIGHTING_JOLT: PackedScene = preload("res://10Lighting/SettingUpOurScenes/lighting_jolt.tscn")

@export_range(0.0, 3.0, 0.1) var flash_time: float = 0.1

@export_range(1, 10, 1) var flashes: int = 3

var target_point := Vector2.ZERO

func _physics_process(delta: float) -> void:
	target_point = to_global(get_target_position())
	if is_colliding():
		target_point = get_collision_point()

func shoot() -> void:
	for flash: int in flashes:
		var jolt: LightingJolt = LIGHTING_JOLT.instantiate()
		add_child(jolt)
		jolt.create(get_global_position(), target_point)
		
		await get_tree().create_timer(flash_time).timeout
