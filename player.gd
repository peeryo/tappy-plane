extends Node2D
 
@onready var area_2d = $Area2D
@onready var timer = $Timer
@onready var cpu_particles_2d = $CPUParticles2D
 
signal hit_obstacle
 
# Declare variables
var gravity: float = 1000.0
var flap_strength: float = -400.0
var motion: Vector2 = Vector2.ZERO
 
var max_rotation_angle: float = PI / 4 
var rotation_speed: float = 5.0
 
var can_flap: bool = true
 
func _ready() -> void:
	area_2d.area_entered.connect(Callable(self, "_on_area_2d_area_entered"))
	timer.timeout.connect(death)
 
func _on_area_2d_area_entered(area):
	timer.start()
	cpu_particles_2d.emitting = true
	can_flap = false
	area_2d.queue_free()
 
func death():
	emit_signal("hit_obstacle")
 
func _process(delta: float) -> void:
	motion.y += gravity * delta
 
	if can_flap and Input.is_action_just_pressed("ui_accept"):
		motion.y = flap_strength
 
	var target_rotation = motion.y / 1000.0 * max_rotation_angle
	rotation = lerp(rotation, target_rotation, rotation_speed * delta)
 
	position += motion * delta
