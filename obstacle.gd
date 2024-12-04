extends Area2D
@onready var sprite_2d = $Sprite2D
@onready var collision_shape: CollisionPolygon2D = $CollisionPolygon2D

var scroll_speed: float= 200.0
var directionUp: bool = true
signal obstacle_passed

var collision_disabled: bool = false 

func _ready() -> void:
	var actual_texture_size = sprite_2d.texture.get_size()
	var half_size= actual_texture_size.y/2
	
	randomize()
	var pipe_height = randf_range(-half_size, half_size)
	
	if directionUp:
		position.y= get_viewport().size.y + pipe_height
		
	else:
		scale.y = -1.5
		position.y= 0 + pipe_height

func _process(delta: float) -> void:
	position.x -= scroll_speed * delta
	
	if position.x < -sprite_2d.texture.get_size().x:
		emit_signal("obstacle_passed")
		queue_free()
		
func disable_collision() -> void:
	collision_shape.call_deferred("set_disabled", true)  # Defer the state change
	collision_disabled = true
	
func enable_collision() -> void:
	collision_shape.disabled = false
	collision_disabled = false	
