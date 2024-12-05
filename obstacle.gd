extends Area2D

@onready var sprite_2d = $Sprite2D
@onready var collision_shape: CollisionPolygon2D = $CollisionPolygon2D

var scroll_speed: float = 200.0
var directionUp: bool = true
signal obstacle_passed

func _ready() -> void:
	# Set the name of the obstacle for collision identification
	self.name = "Obstacle"

func _process(delta: float) -> void:
	# Move the obstacle to the left
	position.x -= scroll_speed * delta

	# Remove the obstacle if it moves off-screen
	if position.x < -sprite_2d.texture.get_size().x:
		emit_signal("obstacle_passed")  # Emit signal for scoring
		queue_free()

func disable_collision() -> void:
	# Defer disabling the collision shape to avoid runtime conflicts
	if is_instance_valid(collision_shape):
		collision_shape.call_deferred("set_disabled", true)

func enable_collision() -> void:
	# Re-enable the collision shape
	if is_instance_valid(collision_shape):
		collision_shape.disabled = false
