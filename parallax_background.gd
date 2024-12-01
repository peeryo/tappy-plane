extends ParallaxBackground

var scroll_speed: float = 200.0

func _process(delta: float) -> void:
	for layer in get_children():
		if layer is ParallaxLayer:
			var motion_scale = layer.motion_scale
			var layer_offset = layer.motion_offset
			layer_offset.x -= scroll_speed * delta * motion_scale.x
			layer.motion_offset = layer_offset
