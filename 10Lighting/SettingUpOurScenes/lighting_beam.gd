class_name LightingBeam extends RayCast2D

const LIGHTING_JOLT: PackedScene = preload("res://10Lighting/SettingUpOurScenes/lighting_jolt.tscn")

@export_range(0.0, 3.0, 0.1) var flash_time: float = 0.1

@export_range(1, 10, 1) var flashes: int = 3
@export_range(0, 10, 1) var bounces_max: int = 3

var target_point := Vector2.ZERO

@onready var jump_area: Area2D = %JumpArea

func _physics_process(delta: float) -> void:
	target_point = to_global(get_target_position())
	if is_colliding():
		target_point = get_collision_point()
	
	jump_area.set_global_position(target_point)

func shoot() -> void:
	var _target_point: Vector2 = target_point
	
	var primary_body: Node2D = get_collider()
	var secondary_bodies: Array[Node2D] = jump_area.get_overlapping_bodies()
	if primary_body:
		secondary_bodies.erase(primary_body)
		_target_point = primary_body.get_global_position()
	
	for flash: int in flashes:
		var _start: Vector2 = get_global_position()
		
		var jolt: LightingJolt = LIGHTING_JOLT.instantiate()
		add_child(jolt)
		jolt.create(_start, target_point)
		
		_start = _target_point
		for i: int in range(min(bounces_max, secondary_bodies.size())):
			var body: Node2D = secondary_bodies[i]
			
			jolt = LIGHTING_JOLT.instantiate()
			add_child(jolt)
			jolt.create(_start, body.get_global_position())
			
			_start = body.get_global_position()
		
		await get_tree().create_timer(flash_time).timeout
