extends Node2D

# Signals
signal hit_obstacle

# Node References
@onready var sprite_2d = $Sprite2D
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var timer = $Timer  # Corrected path
@onready var cpu_particles_2d = $CPUParticles2D
@onready var forcefield = $Forcefield
@onready var collision_shape_FF = $Forcefield/CollisionShape2D
@onready var sprite_2d_FF = $Forcefield/Sprite2D
@onready var forcefield_timer = $Forcefield/ForceFieldTimer

# Physics Variables
var gravity: float = 1000.0
var flap_strength: float = -400.0
var motion: Vector2 = Vector2.ZERO

var max_rotation_angle: float = PI / 4
var rotation_speed: float = 5.0

var can_flap: bool = true
var forcefield_active: bool = false

func _ready() -> void:
	# Initialize forcefield
	forcefield_active = false
	collision_shape_FF.disabled = true
	sprite_2d_FF.visible = false

	# Connect signals
	area_2d.area_entered.connect(_on_area_entered)
	forcefield_timer.timeout.connect(_on_forcefield_timeout)

func _process(delta: float) -> void:
	# Apply gravity to motion
	motion.y += gravity * delta

	# Flap logic
	if can_flap and Input.is_action_just_pressed("ui_accept"):  # Default "ui_accept" is spacebar
		motion.y = flap_strength

	# Update rotation based on motion
	var target_rotation = motion.y / 1000.0 * max_rotation_angle
	rotation = lerp(rotation, target_rotation, rotation_speed * delta)

	# Update position
	position.y += motion.y * delta

func activate_forcefield() -> void:
	# Activate the forcefield if not already active
	if not forcefield_active:
		forcefield_active = true
		collision_shape_FF.disabled = false
		sprite_2d_FF.visible = true
		forcefield_timer.start(3.0)  # Duration of forcefield
		print("Forcefield activated!")

func _on_forcefield_timeout() -> void:
	# Deactivate the forcefield
	forcefield_active = false
	collision_shape_FF.disabled = true
	sprite_2d_FF.visible = false
	print("Forcefield deactivated.")

func _on_area_entered(area: Area2D) -> void:
	# Handle collisions with obstacles
	if area.name == "Obstacle" and not forcefield_active:
		emit_signal("hit_obstacle")  # Notify Main script of collision
		print("Player hit an obstacle!")
