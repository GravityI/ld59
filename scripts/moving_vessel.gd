extends Sprite2D

var target_global_position : Vector2

func _process(delta: float) -> void:
	global_position = global_position.lerp(target_global_position, 1 * delta)
	if global_position.distance_to(target_global_position) < 32:
		queue_free()
