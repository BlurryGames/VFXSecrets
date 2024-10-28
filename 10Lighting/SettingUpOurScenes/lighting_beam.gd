class_name LightingBeam extends RayCast2D

const LIGHTING_JOLT: PackedScene = preload("res://10Lighting/SettingUpOurScenes/lighting_jolt.tscn")

@export_range(0.0, 3.0, 0.1) var flash_time: float = 0.1

@export_range(1, 10, 1) var flashes: int = 3

var target_point := Vector2.ZERO

func _physics_process(delta: float) -> void:
	pass

func shoot() -> void:
	pass
