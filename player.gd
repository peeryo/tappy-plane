extends Node2D
 
@onready var area_2d = $Area2D
@onready var timer = $Timer
@onready var cpu_particles_2d = $CPUParticles2D

#forcefield stuff
@onready var forcefield: Area2D = $Forcefield
@onready var collision_shape_FF: CollisionShape2D = $Forcefield/CollisionShape2D
@onready var sprite_2d_FF: Sprite2D = $Forcefield/Sprite2D
@onready var force_field_timer: Timer = $Forcefield/ForceFieldTimer

 
signal hit_obstacle
 
# Game variables
var gravity: float = 1000.0
var flap_strength: float = -400.0
var motion: Vector2 = Vector2.ZERO
 
var max_rotation_angle: float = PI / 4 
var rotation_speed: float = 5.0
 
var can_flap: bool = true

var forcefield_active: bool = false
 
func _ready() -> void:
	area_2d.area_entered.connect(Callable(self, "_on_area_2d_area_entered"))
	timer.timeout.connect(death)
	
	#forcefield stuff
	forcefield_active = false
	collision_shape_FF.disabled = true
	sprite_2d_FF.visible = false
	force_field_timer.timeout.connect(_on_forcefield_timer_timeout)
	forcefield.area_entered.connect(Callable(self, "_on_forcefield_area_entered"))
 
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
	
	if Input.is_action_just_pressed("forcefield") and not forcefield_active:
		print("forcefield activated")
		activate_forcefield()
		
func _on_forcefield_area_entered(area: Area2D) -> void:
	# Handle collision with obstacles
	if area.name == "Obstacle":
		if forcefield_active:
			print ("forcefield neutralized the object")
			area.queue_free()  # Removes the obstacle
		else:
			print("Player hits an object!")
			timer.start()
			cpu_particles_2d.emitting = true
			can_flap = false

		
func activate_forcefield() -> void:
	print("forcefield activated")
	forcefield_active = true
	collision_shape_FF.disabled = false
	sprite_2d_FF.visible = true
	force_field_timer.start()
	
func _on_forcefield_timer_timeout() -> void:
	print("forcefield deactivated")
	forcefield_active = false
	collision_shape_FF.disabled = true
	sprite_2d_FF.visible = false
