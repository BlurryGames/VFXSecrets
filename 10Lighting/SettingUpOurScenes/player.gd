class_name Player extends Node2D

@onready var lighting = %LightingBeam

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		lighting.shoot()
