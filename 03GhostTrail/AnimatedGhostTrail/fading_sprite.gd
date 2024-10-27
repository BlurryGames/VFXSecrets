class_name FadingSprite extends Sprite2D

@export var lifetime: float = 0.5

func _ready() -> void:
	fade()

func fade(duration: float = lifetime) -> void:
	var transparent: Color = get_modulate()
	transparent.a = 0.0
	
	var tween: Tween = create_tween()
	tween.tween_property(self, ^"modulate", transparent, duration)
	tween.finished.connect(queue_free.call_deferred)
